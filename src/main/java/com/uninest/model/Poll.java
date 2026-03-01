package com.uninest.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Model class representing a poll attached to a community post.
 * Maps to the community_post_polls table.
 */
public class Poll {
    private int id;
    private int postId;
    private String question;
    private boolean allowMultipleChoices;
    private Timestamp createdAt;

    // One-to-Many relationship with PollOption
    private List<PollOption> options = new ArrayList<>();

    // User interaction state (transient, for display)
    private boolean currentUserVoted;
    private List<Integer> currentUserSelectedOptionIds = new ArrayList<>();
    private Timestamp currentUserVoteTimestamp; // When the user voted (for change window)

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public boolean isAllowMultipleChoices() {
        return allowMultipleChoices;
    }

    public void setAllowMultipleChoices(boolean allowMultipleChoices) {
        this.allowMultipleChoices = allowMultipleChoices;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<PollOption> getOptions() {
        return options;
    }

    public void setOptions(List<PollOption> options) {
        this.options = options;
    }

    public void addOption(PollOption option) {
        this.options.add(option);
    }

    public boolean isCurrentUserVoted() {
        return currentUserVoted;
    }

    public void setCurrentUserVoted(boolean currentUserVoted) {
        this.currentUserVoted = currentUserVoted;
    }

    public List<Integer> getCurrentUserSelectedOptionIds() {
        return currentUserSelectedOptionIds;
    }

    public void setCurrentUserSelectedOptionIds(List<Integer> currentUserSelectedOptionIds) {
        this.currentUserSelectedOptionIds = currentUserSelectedOptionIds;
    }

    public Timestamp getCurrentUserVoteTimestamp() {
        return currentUserVoteTimestamp;
    }

    public void setCurrentUserVoteTimestamp(Timestamp currentUserVoteTimestamp) {
        this.currentUserVoteTimestamp = currentUserVoteTimestamp;
    }
}
