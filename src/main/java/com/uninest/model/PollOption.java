package com.uninest.model;

import java.sql.Timestamp;

/**
 * Model class representing an option in a poll.
 * Maps to the community_poll_options table.
 */
public class PollOption {
    private int id;
    private int pollId;
    private String optionText;
    private int voteCount;
    private Timestamp createdAt;

    // Calculated percentage for display
    private double votePercentage;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPollId() {
        return pollId;
    }

    public void setPollId(int pollId) {
        this.pollId = pollId;
    }

    public String getOptionText() {
        return optionText;
    }

    public void setOptionText(String optionText) {
        this.optionText = optionText;
    }

    public int getVoteCount() {
        return voteCount;
    }

    public void setVoteCount(int voteCount) {
        this.voteCount = voteCount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public double getVotePercentage() {
        return votePercentage;
    }

    public void setVotePercentage(double votePercentage) {
        this.votePercentage = votePercentage;
    }
}
