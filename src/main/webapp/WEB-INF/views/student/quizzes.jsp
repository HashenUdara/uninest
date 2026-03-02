<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<layout:student-dashboard pageTitle="My Quizzes" activePage="quizzes">
    <header class="c-page__header">
        <div>
            <h1 class="c-page__title">Quizzes</h1>
            <p class="c-page__subtitle u-text-muted">Test your knowledge with community-created quizzes</p>
        </div>
        <div class="c-page__actions">
            <a href="${pageContext.request.contextPath}/student/quizzes/create" class="c-btn">
                <i data-lucide="plus-circle"></i>
                Create Quiz
            </a>
        </div>
    </header>

    <c:if test="${not empty param.success}">
        <div class="c-alert c-alert--success u-mb-6">
            <div class="c-alert__icon"><i data-lucide="check-circle"></i></div>
            <div class="c-alert__content">
                <p>Quiz created successfully!</p>
            </div>
        </div>
    </c:if>

    <nav class="c-tabs-line u-mb-8" aria-label="Filter">
        <a href="${pageContext.request.contextPath}/student/quizzes" 
           class="${activeTab == 'all' ? 'is-active' : ''}">All Quizzes</a>
        <a href="${pageContext.request.contextPath}/student/quizzes?filter=mine" 
           class="${activeTab == 'mine' ? 'is-active' : ''}">My Quizzes</a>
    </nav>

    <div class="u-grid u-grid-cols-1 u-md-grid-cols-2 u-lg-grid-cols-3 u-gap-6">
        <c:choose>
            <c:when test="${not empty quizzes}">
                <c:forEach var="quiz" items="${quizzes}">
                    <div class="c-card c-card--interactive">
                        <div class="c-card__body">
                            <div class="u-flex u-items-center u-justify-between u-mb-3">
                                <span class="c-badge c-badge--brand">${quiz.subjectName != null ? quiz.subjectName : 'General'}</span>
                                <div class="u-flex u-items-center u-gap-1 u-text-muted u-text-xs">
                                    <i data-lucide="clock" style="width: 14px; height: 14px;"></i>
                                    <span>${quiz.duration}m</span>
                                </div>
                            </div>
                            <h3 class="u-font-bold u-text-lg u-mb-2">${quiz.title}</h3>
                            <p class="u-text-muted u-text-sm u-mb-4 u-line-clamp-2">
                                ${not empty quiz.description ? quiz.description : 'No description provided.'}
                            </p>
                            <div class="u-flex u-items-center u-justify-between u-mt-auto">
                                <div class="u-flex u-items-center u-gap-2">
                                    <div class="u-w-6 u-h-6 u-rounded-full u-bg-surface u-flex u-items-center u-justify-center u-text-xs u-font-bold">
                                        ${fn:substring(quiz.authorName, 0, 1)}
                                    </div>
                                    <span class="u-text-xs u-text-muted">${quiz.authorName}</span>
                                </div>
                                <div class="u-flex u-items-center u-gap-2">
                                    <c:if test="${sessionScope.authUser.id == quiz.authorId}">
                                        <form action="${pageContext.request.contextPath}/student/quizzes/delete" method="POST" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this quiz?');">
                                            <input type="hidden" name="id" value="${quiz.id}">
                                            <button type="submit" class="c-btn c-btn--sm c-btn--ghost u-text-danger" title="Delete Quiz">
                                                <i data-lucide="trash-2" style="width: 14px; height: 14px;"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/student/quizzes/take?id=${quiz.id}" class="c-btn c-btn--sm c-btn--ghost">Take Quiz</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="u-col-span-full u-py-12 u-text-center">
                    <div class="u-inline-flex u-items-center u-justify-center u-w-16 u-h-16 u-rounded-full u-bg-surface u-mb-4 u-text-muted">
                        <i data-lucide="help-circle" style="width: 32px; height: 32px;"></i>
                    </div>
                    <h3 class="u-text-lg u-font-bold u-mb-2">No quizzes found</h3>
                    <p class="u-text-muted">Start by creating the first quiz for your community!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</layout:student-dashboard>
