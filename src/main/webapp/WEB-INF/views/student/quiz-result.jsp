<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:student-dashboard pageTitle="Quiz Result" activePage="quizzes">
    <div class="u-max-w-xl u-mx-auto u-py-12 u-text-center">
        <div class="u-inline-flex u-items-center u-justify-center u-w-24 u-h-24 u-rounded-full u-bg-surface u-mb-6">
            <i data-lucide="trophy" style="width: 48px; height: 48px; color: #f59e0b;"></i>
        </div>
        
        <h1 class="u-text-3xl u-font-bold u-mb-2">Quiz Completed!</h1>
        <p class="u-text-muted u-mb-8">You've successfully finished <strong>${quiz.title}</strong></p>
        
        <div class="c-card u-mb-8">
            <div class="c-card__body u-p-8">
                <div class="u-text-sm u-text-muted u-uppercase u-tracking-wider u-mb-2">Your Score</div>
                <div class="u-text-5xl u-font-bold u-text-brand u-mb-4">${score} / ${totalPoints}</div>
                <div class="c-progress u-h-3 u-bg-surface u-rounded-full u-overflow-hidden">
                    <div class="u-h-full u-bg-brand" style="width: ${(score/totalPoints)*100}%"></div>
                </div>
            </div>
        </div>
        
        <div class="u-flex u-items-center u-justify-center u-gap-4">
            <a href="${pageContext.request.contextPath}/student/quizzes" class="c-btn c-btn--ghost">Back to Quizzes</a>
            <a href="${pageContext.request.contextPath}/student/dashboard" class="c-btn">Go Home</a>
        </div>
    </div>
</layout:student-dashboard>
