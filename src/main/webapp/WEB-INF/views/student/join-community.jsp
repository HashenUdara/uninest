<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Join Community">
  <h1 class="c-auth__title">Enter your community ID</h1>
  <p class="c-text c-text--muted">Ask your moderator for the approved community ID.</p>
  
  <c:if test="${not empty error}">
    <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
  </c:if>
  
  <c:if test="${not empty success}">
    <div style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4); color: #22c55e;">${success}</div>
  </c:if>
  
  <c:if test="${not empty pendingRequest}">
    <div class="c-request-status">
      <div class="c-request-status__header">
        <span class="c-request-status__icon" aria-hidden="true">
          <i data-lucide="clock"></i>
        </span>
        <div class="c-request-status__info">
          <h3 class="c-request-status__title">Pending Request</h3>
          <p class="c-request-status__text">Waiting for moderator approval</p>
        </div>
      </div>
      <div class="c-request-status__details">
        <div class="c-request-status__row">
          <span class="c-request-status__label">Community:</span>
          <span class="c-request-status__value">${pendingRequest.communityTitle}</span>
        </div>
        <div class="c-request-status__row">
          <span class="c-request-status__label">Community ID:</span>
          <span class="c-request-status__value">${pendingRequest.communityId}</span>
        </div>
        <div class="c-request-status__row">
          <span class="c-request-status__label">Status:</span>
          <span class="c-request-status__badge c-request-status__badge--pending">Pending</span>
        </div>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/student/cancel-join-request" class="c-request-status__form">
        <input type="hidden" name="id" value="${pendingRequest.id}" />
        <button type="submit" class="c-btn c-btn--ghost c-btn--full" onclick="return confirm('Are you sure you want to cancel this join request?');">
          Cancel Request
        </button>
      </form>
    </div>
  </c:if>
  
  <c:if test="${empty pendingRequest}">
    <form class="c-auth__form js-auth-form" method="post" action="${pageContext.request.contextPath}/student/join-community" novalidate>
      <div class="c-field" style="grid-column: 1 / -1;">
        <label for="communityId" class="c-field__label">Community ID</label>
        <input type="number" id="communityId" name="communityId" class="c-field__input" placeholder="e.g. 1024" required />
        <p class="c-field__error" data-error-for="communityId" aria-live="polite"></p>
      </div>
      <button type="submit" class="c-btn c-btn--primary c-auth__submit" style="grid-column: 1 / -1;">Join</button>
    </form>
  </c:if>
  
  <jsp:attribute name="scripts">
    <style>
      .c-request-status {
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-md);
        padding: var(--space-6);
        margin-bottom: var(--space-6);
      }
      
      .c-request-status__header {
        display: flex;
        align-items: flex-start;
        gap: var(--space-4);
        margin-bottom: var(--space-5);
      }
      
      .c-request-status__icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        background: rgba(245, 158, 11, 0.1);
        border-radius: var(--radius-md);
        color: #f59e0b;
        flex-shrink: 0;
      }
      
      .c-request-status__info {
        flex: 1;
      }
      
      .c-request-status__title {
        margin: 0 0 var(--space-1) 0;
        font-size: var(--fs-lg);
        font-weight: var(--fw-semibold);
        color: var(--color-text);
      }
      
      .c-request-status__text {
        margin: 0;
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
      }
      
      .c-request-status__details {
        background: var(--color-surface);
        border-radius: var(--radius-sm);
        padding: var(--space-4);
        margin-bottom: var(--space-5);
      }
      
      .c-request-status__row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: var(--space-2) 0;
      }
      
      .c-request-status__row:not(:last-child) {
        border-bottom: 1px solid var(--color-border);
      }
      
      .c-request-status__label {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
        font-weight: var(--fw-medium);
      }
      
      .c-request-status__value {
        font-size: var(--fs-sm);
        color: var(--color-text);
        font-weight: var(--fw-medium);
      }
      
      .c-request-status__badge {
        display: inline-block;
        padding: var(--space-1) var(--space-3);
        border-radius: var(--radius-pill);
        font-size: var(--fs-xs);
        font-weight: var(--fw-semibold);
        text-transform: uppercase;
        letter-spacing: 0.025em;
      }
      
      .c-request-status__badge--pending {
        background: rgba(245, 158, 11, 0.1);
        color: #f59e0b;
      }
      
      .c-request-status__form {
        margin: 0;
      }
      
      .c-btn--full {
        width: 100%;
      }
    </style>
  </jsp:attribute>
</layout:auth>
