<%@ tag description="Community Posts section for dashboard" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="posts" required="true" type="java.util.List" rtexprvalue="true" description="List of CommunityPost objects" %>
<%@ attribute name="currentUser" required="true" type="com.uninest.model.User" rtexprvalue="true" description="Current logged-in user" %>
<%@ attribute name="contextPath" required="true" description="Application context path" %>

<div class="section-card">
  <div class="section-header">
    <h2 class="section-title">
      <i data-lucide="message-square"></i>
      Community Highlights
    </h2>
    <a href="${contextPath}/student/community" class="section-link">
      View All
      <i data-lucide="arrow-right"></i>
    </a>
  </div>
  <div class="section-body" style="padding: 0">
    <!-- Post Creation Form -->
    <form action="${contextPath}/student/dashboard" method="post" class="community-post" style="border-bottom: 2px solid var(--color-border);">
      <div class="post-header">
        <div class="post-avatar">
          <c:choose>
            <c:when test="${fn:contains(currentUser.name, ' ')}">
              ${fn:substring(currentUser.name, 0, 1)}${fn:substring(fn:substringAfter(currentUser.name, ' '), 0, 1)}
            </c:when>
            <c:otherwise>
              ${fn:substring(currentUser.name, 0, 2)}
            </c:otherwise>
          </c:choose>
        </div>
        <div class="post-author-info" style="flex: 1;">
          <textarea name="postContent" placeholder="Share something with your community..." 
            style="width: 100%; min-height: 60px; padding: var(--space-3); border: 2px solid var(--color-border); border-radius: var(--radius-md); font-family: inherit; font-size: var(--fs-sm); resize: vertical; transition: border-color 0.2s ease;"
            onfocus="this.style.borderColor='var(--color-brand)'" 
            onblur="this.style.borderColor='var(--color-border)'"
            required></textarea>
        </div>
      </div>
      <div style="display: flex; justify-content: flex-end; padding-top: var(--space-3);">
        <button type="submit" class="post-submit-btn" style="background: linear-gradient(135deg, var(--color-brand) 0%, #6d4ef7 100%); color: white; border: none; padding: var(--space-2) var(--space-5); border-radius: var(--radius-md); font-weight: 600; font-size: var(--fs-sm); cursor: pointer; display: flex; align-items: center; gap: var(--space-2); transition: transform 0.2s ease, box-shadow 0.2s ease;"
          onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(84, 44, 245, 0.3)';"
          onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
          <i data-lucide="send" style="width: 16px; height: 16px;"></i>
          Post
        </button>
      </div>
    </form>

    <!-- Dynamic Community Posts -->
    <c:choose>
      <c:when test="${not empty posts}">
        <c:forEach var="post" items="${posts}">
          <div class="community-post">
            <div class="post-header">
              <div class="post-avatar">${post.userInitials}</div>
              <div class="post-author-info">
                <div class="post-author">${post.userName}</div>
                <div class="post-time">${post.relativeTime}</div>
              </div>
            </div>
            <div class="post-content">
              <c:out value="${post.content}" />
            </div>
            <div class="post-stats">
              <span class="post-stat">
                <i data-lucide="heart"></i>
                ${post.likeCount} ${post.likeCount == 1 ? 'like' : 'likes'}
              </span>
              <span class="post-stat">
                <i data-lucide="message-circle"></i>
                ${post.commentCount} ${post.commentCount == 1 ? 'comment' : 'comments'}
              </span>
            </div>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <div class="empty-state">
          <div class="empty-state-icon">
            <i data-lucide="message-square"></i>
          </div>
          <h3>No posts yet</h3>
          <p>Be the first to share something with your community!</p>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>
