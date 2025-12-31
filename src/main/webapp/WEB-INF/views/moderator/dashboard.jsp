<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:moderator-dashboard activePage="dashboard">
 <style>
      .dashboard-container {
        max-width: 1400px;
        margin: 0 auto;
      }

      /* Welcome Section */
      .welcome-section {
        background: linear-gradient(
          135deg,
          var(--color-brand) 0%,
          #6d4ef7 100%
        );
        border-radius: var(--radius-xl);
        padding: var(--space-8);
        margin-bottom: var(--space-8);
        color: white;
        position: relative;
        overflow: hidden;
      }

      .welcome-section::before {
        content: "";
        position: absolute;
        top: -50%;
        right: -10%;
        width: 400px;
        height: 400px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 50%;
        z-index: 0;
      }

      .welcome-content {
        position: relative;
        z-index: 1;
      }

      .welcome-greeting {
        font-size: var(--fs-3xl);
        font-weight: 700;
        margin: 0 0 var(--space-3) 0;
        letter-spacing: -0.02em;
      }

      .welcome-message {
        font-size: var(--fs-lg);
        opacity: 0.95;
        margin: 0;
        line-height: 1.5;
      }

      /* Stats Grid */
      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: var(--space-5);
        margin-bottom: var(--space-8);
      }

      .stat-card {
        background: var(--color-white);
        border: 2px solid var(--color-border);
        border-radius: var(--radius-xl);
        padding: var(--space-6);
        display: flex;
        align-items: center;
        gap: var(--space-4);
        transition: all 0.3s ease;
      }

      .stat-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
      }

      .stat-icon {
        width: 64px;
        height: 64px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: var(--radius-lg);
        flex-shrink: 0;
      }

      .stat-icon i {
        width: 32px;
        height: 32px;
      }

      .stat-icon--pending {
        background: linear-gradient(
          135deg,
          rgba(245, 158, 11, 0.1) 0%,
          rgba(245, 158, 11, 0.05) 100%
        );
        color: #f59e0b;
      }

      .stat-icon--success {
        background: linear-gradient(
          135deg,
          rgba(16, 185, 129, 0.1) 0%,
          rgba(16, 185, 129, 0.05) 100%
        );
        color: #10b981;
      }

      .stat-icon--danger {
        background: linear-gradient(
          135deg,
          rgba(239, 68, 68, 0.1) 0%,
          rgba(239, 68, 68, 0.05) 100%
        );
        color: #ef4444;
      }

      .stat-icon--info {
        background: linear-gradient(
          135deg,
          rgba(59, 130, 246, 0.1) 0%,
          rgba(59, 130, 246, 0.05) 100%
        );
        color: #3b82f6;
      }

      .stat-content {
        flex: 1;
      }

      .stat-label {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
        margin: 0 0 var(--space-2) 0;
      }

      .stat-value {
        font-size: var(--fs-3xl);
        font-weight: 700;
        color: var(--color-text);
        margin: 0;
        line-height: 1;
      }

      .stat-change {
        font-size: var(--fs-xs);
        margin-top: var(--space-2);
        display: flex;
        align-items: center;
        gap: var(--space-1);
      }

      .stat-change--up {
        color: #10b981;
      }

      .stat-change--down {
        color: #ef4444;
      }

      .stat-change i {
        width: 12px;
        height: 12px;
      }

      /* Quick Actions */
      .quick-actions {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: var(--space-5);
        margin-bottom: var(--space-8);
      }

      .action-card {
        background: var(--color-white);
        border: 2px solid var(--color-border);
        border-radius: var(--radius-xl);
        padding: var(--space-6);
        text-align: center;
        transition: all 0.3s ease;
        cursor: pointer;
        text-decoration: none;
        color: inherit;
      }

      .action-card:hover {
        border-color: var(--color-brand);
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(84, 44, 245, 0.12);
      }

      .action-icon {
        width: 56px;
        height: 56px;
        margin: 0 auto var(--space-4);
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: var(--radius-lg);
        background: linear-gradient(
          135deg,
          rgba(84, 44, 245, 0.1) 0%,
          rgba(84, 44, 245, 0.05) 100%
        );
        color: var(--color-brand);
      }

      .action-icon i {
        width: 28px;
        height: 28px;
      }

      .action-card h3 {
        font-size: var(--fs-base);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-2) 0;
      }

      .action-card p {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
        margin: 0;
      }

      /* Main Grid Layout */
      .dashboard-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: var(--space-6);
        margin-bottom: var(--space-8);
      }

      /* Section Card */
      .section-card {
        background: var(--color-white);
        border: 2px solid var(--color-border);
        border-radius: var(--radius-xl);
        overflow: hidden;
      }

      .section-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: var(--space-6) var(--space-8);
        background: linear-gradient(
          135deg,
          var(--color-surface) 0%,
          rgba(84, 44, 245, 0.02) 100%
        );
        border-bottom: 2px solid var(--color-border);
      }

      .section-title {
        display: flex;
        align-items: center;
        gap: var(--space-3);
        font-size: var(--fs-xl);
        font-weight: 700;
        color: var(--color-text);
        margin: 0;
      }

      .section-title i {
        width: 24px;
        height: 24px;
        color: var(--color-brand);
      }

      .section-link {
        font-size: var(--fs-sm);
        font-weight: 600;
        color: var(--color-brand);
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: var(--space-2);
        transition: all 0.2s ease;
      }

      .section-link:hover {
        gap: var(--space-3);
      }

      .section-link i {
        width: 16px;
        height: 16px;
      }

      .section-body {
        padding: var(--space-6) var(--space-8);
      }

      /* Pending Items */
      .pending-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: var(--space-5);
        background: var(--color-surface);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-4);
        transition: all 0.2s ease;
      }

      .pending-item:hover {
        background: rgba(84, 44, 245, 0.05);
      }

      .pending-item:last-child {
        margin-bottom: 0;
      }

      .pending-info {
        display: flex;
        align-items: center;
        gap: var(--space-4);
        flex: 1;
      }

      .pending-icon {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: var(--color-white);
        border: 2px solid var(--color-border);
        border-radius: var(--radius-md);
        color: #f59e0b;
        flex-shrink: 0;
      }

      .pending-icon i {
        width: 20px;
        height: 20px;
      }

      .pending-details h4 {
        font-size: var(--fs-sm);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-1) 0;
      }

      .pending-details p {
        font-size: var(--fs-xs);
        color: var(--color-text-muted);
        margin: 0;
      }

      .pending-action {
        padding: var(--space-2) var(--space-4);
        background: var(--color-brand);
        color: white;
        border: none;
        border-radius: var(--radius-md);
        font-size: var(--fs-sm);
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
      }

      .pending-action:hover {
        background: #6d4ef7;
        transform: translateY(-2px);
      }

      /* Activity List */
      .activity-item {
        display: flex;
        gap: var(--space-4);
        padding: var(--space-4) 0;
        border-bottom: 1px solid var(--color-border);
      }

      .activity-item:last-child {
        border-bottom: none;
        padding-bottom: 0;
      }

      .activity-item:first-child {
        padding-top: 0;
      }

      .activity-icon {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        flex-shrink: 0;
        font-size: var(--fs-sm);
        font-weight: 700;
      }

      .activity-icon--success {
        background: linear-gradient(
          135deg,
          var(--color-brand) 0%,
          #6d4ef7 100%
        );
        color: white;
      }

      .activity-icon--warning {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        color: white;
      }

      .activity-icon--danger {
        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        color: white;
      }

      .activity-content {
        flex: 1;
      }

      .activity-text {
        font-size: var(--fs-sm);
        color: var(--color-text);
        margin: 0 0 var(--space-1) 0;
        line-height: 1.5;
      }

      .activity-text strong {
        font-weight: 600;
      }

      .activity-time {
        font-size: var(--fs-xs);
        color: var(--color-text-muted);
      }

      /* Report Items */
      .report-item {
        padding: var(--space-5);
        background: var(--color-surface);
        border-left: 4px solid #ef4444;
        border-radius: var(--radius-md);
        margin-bottom: var(--space-4);
      }

      .report-item:last-child {
        margin-bottom: 0;
      }

      .report-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: var(--space-3);
      }

      .report-type {
        display: inline-flex;
        align-items: center;
        gap: var(--space-2);
        padding: var(--space-1) var(--space-3);
        background: rgba(239, 68, 68, 0.1);
        color: #ef4444;
        border-radius: var(--radius-md);
        font-size: var(--fs-xs);
        font-weight: 600;
      }

      .report-type i {
        width: 12px;
        height: 12px;
      }

      .report-time {
        font-size: var(--fs-xs);
        color: var(--color-text-muted);
      }

      .report-content {
        font-size: var(--fs-sm);
        color: var(--color-text);
        margin-bottom: var(--space-3);
      }

      .report-actions {
        display: flex;
        gap: var(--space-3);
      }

      .report-actions button {
        padding: var(--space-2) var(--space-4);
        border: 2px solid var(--color-border);
        border-radius: var(--radius-md);
        font-size: var(--fs-sm);
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        background: var(--color-white);
      }

      .report-actions button:hover {
        transform: translateY(-2px);
      }

      .btn-approve {
        color: #10b981;
        border-color: #10b981;
      }

      .btn-approve:hover {
        background: #10b981;
        color: white;
      }

      .btn-reject {
        color: #ef4444;
        border-color: #ef4444;
      }

      .btn-reject:hover {
        background: #ef4444;
        color: white;
      }

      .btn-view {
        color: var(--color-brand);
        border-color: var(--color-brand);
      }

      .btn-view:hover {
        background: var(--color-brand);
        color: white;
      }

      /* Full Width Section */
      .section-full {
        grid-column: 1 / -1;
      }

      /* Community Info Card */
      .community-card {
        background: linear-gradient(
          135deg,
          var(--color-brand) 0%,
          #6d4ef7 100%
        );
        border-radius: var(--radius-xl);
        padding: var(--space-6);
        margin-bottom: var(--space-6);
        color: white;
        display: flex;
        align-items: center;
        justify-content: space-between;
        box-shadow: 0 4px 12px rgba(84, 44, 245, 0.2);
      }

      .community-info {
        flex: 1;
      }

      .community-label {
        font-size: var(--fs-sm);
        opacity: 0.9;
        margin-bottom: var(--space-2);
        font-weight: 500;
      }

      .community-name {
        font-size: var(--fs-2xl);
        font-weight: 700;
        margin: 0 0 var(--space-2) 0;
        letter-spacing: -0.02em;
      }

      .community-id {
        display: inline-flex;
        align-items: center;
        gap: var(--space-2);
        padding: var(--space-2) var(--space-4);
        background: rgba(255, 255, 255, 0.2);
        border-radius: var(--radius-md);
        font-size: var(--fs-sm);
        font-weight: 600;
        font-family: monospace;
      }

      .community-id i {
        width: 16px;
        height: 16px;
      }

      .community-icon {
        width: 80px;
        height: 80px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(255, 255, 255, 0.15);
        border-radius: var(--radius-lg);
      }

      .community-icon i {
        width: 40px;
        height: 40px;
      }

      @media (max-width: 1024px) {
        .dashboard-grid {
          grid-template-columns: 1fr;
        }

        .stats-grid {
          grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        }
      }

      @media (max-width: 768px) {
        .welcome-section {
          padding: var(--space-6);
        }

        .welcome-greeting {
          font-size: var(--fs-2xl);
        }

        .welcome-message {
          font-size: var(--fs-base);
        }

        .quick-actions {
          grid-template-columns: 1fr;
        }

        .section-header {
          flex-direction: column;
          align-items: flex-start;
          gap: var(--space-3);
        }

        .community-card {
          flex-direction: column;
          text-align: center;
          gap: var(--space-4);
        }

        .community-icon {
          order: -1;
        }
      }
    </style>



<div class="dashboard-container">
          <!-- Welcome Section -->
          <div class="welcome-section">
            <div class="welcome-content">
              <h1 class="welcome-greetin">Welcome back, ${sessionScope.authUser.email}! 👋</h1>
              <p class="welcome-message">
                Here's your moderation overview for today. Keep up the great
                work maintaining our community!
              </p>
            </div>
          </div>

          <!-- Community Info Card -->
          <div class="community-card">
            <div class="community-info">
              <div class="community-label">Moderating Community</div>
              <h2 class="community-name">${community.title}</h2>
              <div class="community-id">
                <i data-lucide="hash"></i>
                <span>${community.id}</span>
              </div>
            </div>
            <div class="community-icon">
              <i data-lucide="users"></i>
            </div>
          </div>

          <!-- Stats Grid -->
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-icon stat-icon--pending">
                <i data-lucide="clock"></i>
              </div>
              <div class="stat-content">
                <p class="stat-label">Pending Reviews</p>
                <h3 class="stat-value">12</h3>
                <div class="stat-change stat-change--up">
                  <i data-lucide="trending-up"></i>
                  <span>3 new today</span>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon stat-icon--success">
                <i data-lucide="check-circle"></i>
              </div>
              <div class="stat-content">
                <p class="stat-label">Approved Today</p>
                <h3 class="stat-value">24</h3>
                <div class="stat-change stat-change--up">
                  <i data-lucide="trending-up"></i>
                  <span>+8 from yesterday</span>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon stat-icon--danger">
                <i data-lucide="alert-triangle"></i>
              </div>
              <div class="stat-content">
                <p class="stat-label">Reports Pending</p>
                <h3 class="stat-value">5</h3>
                <div class="stat-change stat-change--down">
                  <i data-lucide="trending-down"></i>
                  <span>-2 from yesterday</span>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon stat-icon--info">
                <i data-lucide="users"></i>
              </div>
              <div class="stat-content">
                <p class="stat-label">Active Users</p>
                <h3 class="stat-value">342</h3>
                <div class="stat-change stat-change--up">
                  <i data-lucide="trending-up"></i>
                  <span>+15% this week</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Actions -->
          <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/moderator/subjects" class="action-card">
              <div class="action-icon">
                <i data-lucide="clipboard-check"></i>
              </div>
              <h3>Manage Subjects</h3>
              <p>View and manage subjects</p>
            </a>

            <a href="${pageContext.request.contextPath}/moderator/students" class="action-card">
              <div class="action-icon">
                <i data-lucide="file-text"></i>
              </div>
              <h3>Manage Students</h3>
              <p>View and manage students</p>
            </a>

            <a href="${pageContext.request.contextPath}/moderator/join-requests" class="action-card">
              <div class="action-icon">
                <i data-lucide="message-square"></i>
              </div>
              <h3>Join Requests</h3>
              <p>Review pending requests</p>
            </a>

            <a href="${pageContext.request.contextPath}/moderator/subjects/create" class="action-card">
              <div class="action-icon">
                <i data-lucide="users"></i>
              </div>
              <h3>Create Subject</h3>
              <p>Add new subject</p>
            </a>
          </div>

          <!-- Main Grid Layout -->
          <div class="dashboard-grid">
            <!-- Pending Quizzes -->
            <div class="section-card">
              <div class="section-header">
                <h2 class="section-title">
                  <i data-lucide="clipboard-list"></i>
                  Pending Join Requests
                </h2>
                <a href="${pageContext.request.contextPath}/moderator/join-requests" class="section-link">
                  View All
                  <i data-lucide="arrow-right"></i>
                </a>
              </div>
              <div class="section-body">
                <div class="pending-item">
                  <div class="pending-info">
                    <div class="pending-icon">
                      <i data-lucide="help-circle"></i>
                    </div>
                    <div class="pending-details">
                      <h4>Student Join Request</h4>
                      <p>Submitted by Tharindu Fernando • 2 hours ago</p>
                    </div>
                  </div>
                  <a href="${pageContext.request.contextPath}/moderator/join-requests" class="pending-action" style="text-decoration: none;">Review</a>
                </div>

                <div class="pending-item">
                  <div class="pending-info">
                    <div class="pending-icon">
                      <i data-lucide="help-circle"></i>
                    </div>
                    <div class="pending-details">
                      <h4>Student Join Request</h4>
                      <p>Submitted by Nuwan Silva • 4 hours ago</p>
                    </div>
                  </div>
                  <a href="${pageContext.request.contextPath}/moderator/join-requests" class="pending-action" style="text-decoration: none;">Review</a>
                </div>

                <div class="pending-item">
                  <div class="pending-info">
                    <div class="pending-icon">
                      <i data-lucide="help-circle"></i>
                    </div>
                    <div class="pending-details">
                      <h4>Student Join Request</h4>
                      <p>Submitted by Hashen Udara • 6 hours ago</p>
                    </div>
                  </div>
                  <a href="${pageContext.request.contextPath}/moderator/join-requests" class="pending-action" style="text-decoration: none;">Review</a>
                </div>
              </div>
            </div>

            <!-- Recent Activity -->
            <div class="section-card">
              <div class="section-header">
                <h2 class="section-title">
                  <i data-lucide="activity"></i>
                  Recent Activity
                </h2>
              </div>
              <div class="section-body">
                <div class="activity-item">
                  <div class="activity-icon activity-icon--success">
                    <i data-lucide="check"></i>
                  </div>
                  <div class="activity-content">
                    <p class="activity-text">
                      Approved quiz <strong>"Data Structures Basics"</strong>
                    </p>
                    <p class="activity-time">30 minutes ago</p>
                  </div>
                </div>

                <div class="activity-item">
                  <div class="activity-icon activity-icon--success">
                    <i data-lucide="check"></i>
                  </div>
                  <div class="activity-content">
                    <p class="activity-text">
                      Approved resource <strong>"OOP Lecture Notes"</strong>
                    </p>
                    <p class="activity-time">1 hour ago</p>
                  </div>
                </div>

                <div class="activity-item">
                  <div class="activity-icon activity-icon--danger">
                    <i data-lucide="x"></i>
                  </div>
                  <div class="activity-content">
                    <p class="activity-text">
                      Rejected quiz <strong>"Incomplete Quiz Set"</strong>
                    </p>
                    <p class="activity-time">2 hours ago</p>
                  </div>
                </div>

                <div class="activity-item">
                  <div class="activity-icon activity-icon--warning">
                    <i data-lucide="alert-circle"></i>
                  </div>
                  <div class="activity-content">
                    <p class="activity-text">
                      Resolved report for post <strong>"Spam content"</strong>
                    </p>
                    <p class="activity-time">3 hours ago</p>
                  </div>
                </div>

                <div class="activity-item">
                  <div class="activity-icon activity-icon--success">
                    <i data-lucide="check"></i>
                  </div>
                  <div class="activity-content">
                    <p class="activity-text">
                      Approved organization <strong>"CS Students Union"</strong>
                    </p>
                    <p class="activity-time">5 hours ago</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Pending Reports -->
            <div class="section-card section-full">
              <div class="section-header">
                <h2 class="section-title">
                  <i data-lucide="flag"></i>
                  Pending Reports
                </h2>
                <a href="#" class="section-link">
                  View All
                  <i data-lucide="arrow-right"></i>
                </a>
              </div>
              <div class="section-body">
                <div class="report-item">
                  <div class="report-header">
                    <span class="report-type">
                      <i data-lucide="alert-octagon"></i>
                      Inappropriate Content
                    </span>
                    <span class="report-time">15 minutes ago</span>
                  </div>
                  <div class="report-content">
                    <strong>Reported Post:</strong> "Advanced JavaScript
                    Concepts Discussion"<br />
                    <strong>Reason:</strong> Contains offensive language and
                    inappropriate content
                  </div>
                  <div class="report-actions">
                    <button class="btn-view">View Post</button>
                    <button class="btn-approve">Dismiss Report</button>
                    <button class="btn-reject">Remove Content</button>
                  </div>
                </div>

                <div class="report-item">
                  <div class="report-header">
                    <span class="report-type">
                      <i data-lucide="alert-octagon"></i>
                      Spam
                    </span>
                    <span class="report-time">1 hour ago</span>
                  </div>
                  <div class="report-content">
                    <strong>Reported Resource:</strong> "Free Course Download
                    Link"<br />
                    <strong>Reason:</strong> Suspicious external links,
                    potential spam
                  </div>
                  <div class="report-actions">
                    <button class="btn-view">View Resource</button>
                    <button class="btn-approve">Dismiss Report</button>
                    <button class="btn-reject">Remove Resource</button>
                  </div>
                </div>

                <div class="report-item">
                  <div class="report-header">
                    <span class="report-type">
                      <i data-lucide="alert-octagon"></i>
                      Copyright Violation
                    </span>
                    <span class="report-time">2 hours ago</span>
                  </div>
                  <div class="report-content">
                    <strong>Reported Resource:</strong> "Complete Java
                    Programming Book PDF"<br />
                    <strong>Reason:</strong> Copyrighted material shared without
                    permission
                  </div>
                  <div class="report-actions">
                    <button class="btn-view">View Resource</button>
                    <button class="btn-approve">Dismiss Report</button>
                    <button class="btn-reject">Remove Resource</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
<script>
      document.addEventListener("DOMContentLoaded", function () {
        if (window.lucide) window.lucide.createIcons();

        // Get current hour for personalized greeting
        const hour = new Date().getHours();
        let greeting = "Welcome back";

        if (hour < 12) {
          greeting = "Good morning";
        } else if (hour < 18) {
          greeting = "Good afternoon";
        } else {
          greeting = "Good evening";
        }

        // Update greeting
        const greetingElement = document.querySelector(".welcome-greeting");
        if (greetingElement) {
          const userName = "Kavindu";
          greetingElement.textContent = `${greeting}, ${userName}! 👋`;
        }

        // Handle pending action buttons (now they are links, so this is optional)
        const reviewButtons = document.querySelectorAll(".pending-action");
        reviewButtons.forEach((button) => {
          // Already handled by href attribute
        });

        // Handle report action buttons
        const reportButtons = document.querySelectorAll(
          ".report-actions button"
        );
        reportButtons.forEach((button) => {
          button.addEventListener("click", function () {
            const action = this.textContent.trim();
            alert(
              `Action: ${action}\n\nThis would ${action.toLowerCase()} the reported item.`
            );
          });
        });
      });
    </script>
</layout:moderator-dashboard>
