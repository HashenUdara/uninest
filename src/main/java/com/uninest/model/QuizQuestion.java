package com.uninest.model;

import java.util.ArrayList;
import java.util.List;

public class QuizQuestion {
    private int id;
    private int quizId;
    private String questionText;
    private int points;
    private int orderNum;
    
    private List<QuizOption> options = new ArrayList<>();

    public QuizQuestion() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }

    public int getOrderNum() { return orderNum; }
    public void setOrderNum(int orderNum) { this.orderNum = orderNum; }

    public List<QuizOption> getOptions() { return options; }
    public void setOptions(List<QuizOption> options) { this.options = options; }
    
    public void addOption(QuizOption option) {
        this.options.add(option);
    }
}
