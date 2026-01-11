package com.uninest.model.dao;

import com.uninest.model.Poll;
import com.uninest.model.PollOption;
import com.uninest.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object for polls.
 * Handles CRUD operations for community_post_polls, options, and votes.
 */
public class PollDAO {

    /**
     * Creates a poll and its options for a post.
     */
    public void createPoll(Poll poll) {
        String pollSql = "INSERT INTO community_post_polls (post_id, question, allow_multiple_choices) VALUES (?,?,?)";
        String optionSql = "INSERT INTO community_poll_options (poll_id, option_text) VALUES (?,?)";

        try (Connection con = DBConnection.getConnection()) {
            // Start transaction
            con.setAutoCommit(false);

            try {
                // Insert Poll
                int pollId = 0;
                try (PreparedStatement ps = con.prepareStatement(pollSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, poll.getPostId());
                    ps.setString(2, poll.getQuestion());
                    ps.setBoolean(3, poll.isAllowMultipleChoices());
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) {
                            pollId = keys.getInt(1);
                            poll.setId(pollId);
                        } else {
                            throw new SQLException("Creating poll failed, no ID obtained.");
                        }
                    }
                }

                // Insert Options
                try (PreparedStatement ps = con.prepareStatement(optionSql)) {
                    for (PollOption option : poll.getOptions()) {
                        ps.setInt(1, pollId);
                        ps.setString(2, option.getOptionText());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }

                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating poll", e);
        }
    }

    /**
     * Findings a poll by its post ID.
     * Includes options and vote counts.
     */
    public Optional<Poll> findByPostId(int postId, int currentUserId) {
        String pollSql = "SELECT * FROM community_post_polls WHERE post_id = ?";
        Poll poll = null;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(pollSql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    poll = new Poll();
                    poll.setId(rs.getInt("id"));
                    poll.setPostId(rs.getInt("post_id"));
                    poll.setQuestion(rs.getString("question"));
                    poll.setAllowMultipleChoices(rs.getBoolean("allow_multiple_choices"));
                    poll.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching poll", e);
        }

        if (poll != null) {
            // Fetch options and user vote status
            poll.setOptions(getOptionsForPoll(poll.getId()));

            // Checking if current user voted
            if (currentUserId > 0) {
                List<Integer> votedOptionIds = getUserVotedOptionIds(poll.getId(), currentUserId);
                poll.setCurrentUserSelectedOptionIds(votedOptionIds);
                poll.setCurrentUserVoted(!votedOptionIds.isEmpty());
            }

            return Optional.of(poll);
        }

        return Optional.empty();
    }

    private List<PollOption> getOptionsForPoll(int pollId) {
        String sql = "SELECT * FROM community_poll_options WHERE poll_id = ? ORDER BY id ASC";
        List<PollOption> options = new ArrayList<>();
        int totalVotes = 0;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, pollId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PollOption option = new PollOption();
                    option.setId(rs.getInt("id"));
                    option.setPollId(rs.getInt("poll_id"));
                    option.setOptionText(rs.getString("option_text"));
                    option.setVoteCount(rs.getInt("vote_count"));
                    option.setCreatedAt(rs.getTimestamp("created_at"));

                    totalVotes += option.getVoteCount();
                    options.add(option);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching poll options", e);
        }

        // Calculate percentages
        if (totalVotes > 0) {
            for (PollOption opt : options) {
                double pct = (double) opt.getVoteCount() * 100 / totalVotes;
                opt.setVotePercentage(Math.round(pct * 10.0) / 10.0);
            }
        }

        return options;
    }

    private List<Integer> getUserVotedOptionIds(int pollId, int userId) {
        String sql = "SELECT option_id FROM community_poll_votes WHERE poll_id = ? AND user_id = ?";
        List<Integer> ids = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, pollId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("option_id"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching user votes", e);
        }
        return ids;
    }

    /**
     * Populates the current user's vote state for a given poll.
     */
    public void loadUserVoteState(Poll poll, int userId) {
        if (poll != null && userId > 0) {
            List<Integer> votedOptionIds = getUserVotedOptionIds(poll.getId(), userId);
            poll.setCurrentUserSelectedOptionIds(votedOptionIds);
            poll.setCurrentUserVoted(!votedOptionIds.isEmpty());
        }
    }

    /**
     * Records a vote for a user.
     * Note: Does not handle 'unvoting' or changing votes in this simple version,
     * but supports single/multiple choice logic validation if needed.
     */
    public boolean vote(int pollId, int userId, List<Integer> optionIds) {
        String checkPollSql = "SELECT allow_multiple_choices FROM community_post_polls WHERE id = ?";
        String insertVoteSql = "INSERT INTO community_poll_votes (poll_id, option_id, user_id) VALUES (?,?,?)";
        String updateCountSql = "UPDATE community_poll_options SET vote_count = vote_count + 1 WHERE id = ?";

        try (Connection con = DBConnection.getConnection()) {
            // Check if multiple choice is allowed
            boolean allowMultiple = false;
            try (PreparedStatement ps = con.prepareStatement(checkPollSql)) {
                ps.setInt(1, pollId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        allowMultiple = rs.getBoolean("allow_multiple_choices");
                    } else {
                        return false; // Poll not found
                    }
                }
            }

            if (!allowMultiple && optionIds.size() > 1) {
                throw new IllegalArgumentException("Multiple choices not allowed for this poll");
            }

            con.setAutoCommit(false);
            try {
                // Check if user already voted (for simplicity, we assume frontend checks,
                // but DB unique constraint `unique_user_vote_option` handles duplicates per
                // option.
                // To strictly prevent re-voting on single choice, we'd check existence first.
                // Here we proceed to insert.

                try (PreparedStatement psVote = con.prepareStatement(insertVoteSql);
                        PreparedStatement psCount = con.prepareStatement(updateCountSql)) {

                    for (int optionId : optionIds) {
                        // Insert vote
                        psVote.setInt(1, pollId);
                        psVote.setInt(2, optionId);
                        psVote.setInt(3, userId);
                        psVote.addBatch();

                        // Update count
                        psCount.setInt(1, optionId);
                        psCount.addBatch();
                    }

                    psVote.executeBatch();
                    psCount.executeBatch();
                }

                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                // If duplicate entry (already voted for this option), we might want to swallow
                // or rethrow
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error recording vote", e);
        }
    }
}
