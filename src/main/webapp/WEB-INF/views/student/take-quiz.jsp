<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:student-dashboard pageTitle="Take Quiz: ${quiz.title}" activePage="quizzes">
    <div class="u-max-w-3xl u-mx-auto">
        <header class="u-mb-8">
            <nav class="c-breadcrumbs u-mb-4" aria-label="Breadcrumb">
                <a href="${pageContext.request.contextPath}/student/quizzes">Quizzes</a>
                <span class="c-breadcrumbs__sep">/</span>
                <span aria-current="page">Take Quiz</span>
            </nav>
            <h1 class="c-page__title">${quiz.title}</h1>
            <p class="u-text-muted">${quiz.description}</p>
        </header>

        <form action="${pageContext.request.contextPath}/student/quizzes/take" method="POST">
            <input type="hidden" name="quizId" value="${quiz.id}">
            
            <c:forEach var="question" items="${quiz.questions}" varStatus="status">
                <div class="c-card u-mb-6">
                    <div class="c-card__body">
                        <div class="u-flex u-items-center u-gap-3 u-mb-4">
                            <span class="u-w-8 u-h-8 u-rounded-lg u-bg-brand u-text-white u-flex u-items-center u-justify-center u-font-bold">
                                ${status.count}
                            </span>
                            <span class="u-font-semibold u-text-lg">${question.questionText}</span>
                            <span class="u-ml-auto u-text-xs u-bg-surface u-px-2 u-py-1 u-rounded">${question.points} pts</span>
                        </div>
                        
                        <div class="u-grid u-gap-3">
                            <c:forEach var="option" items="${question.options}">
                                <label class="u-flex u-items-center u-gap-3 u-p-4 u-rounded-lg u-border u-border-border u-cursor-pointer hover:u-bg-surface transition-colors">
                                    <input type="radio" name="q${question.id}" value="${option.id}" required class="u-w-4 u-h-4 u-accent-brand">
                                    <span>${option.optionText}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <div class="u-flex u-justify-end u-mt-8">
                <button type="submit" class="c-btn c-btn--lg">Submit Quiz</button>
            </div>
        </form>
    </div>
</layout:student-dashboard>
