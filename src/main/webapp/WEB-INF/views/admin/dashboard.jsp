<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:admin-dashboard activePage="dashboard">

   <style>
      .dashboard-container {
        max-width: 1400px;
        margin: 0 auto;
      }

      /* Welcome Section */
      .welcome-section {
        background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
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
        cursor: pointer;
        text-decoration: none;
        color: inherit;
      }

      .stat-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        border-color: #3b82f6;
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

      .stat-icon--students {
        background: linear-gradient(
          135deg,
          rgba(59, 130, 246, 0.1) 0%,
          rgba(59, 130, 246, 0.05) 100%
        );
        color: #3b82f6;
      }

      .stat-icon--communities {
        background: linear-gradient(
          135deg,
          rgba(168, 85, 247, 0.1) 0%,
          rgba(168, 85, 247, 0.05) 100%
        );
        color: #a855f7;
      }

      .stat-icon--moderators {
        background: linear-gradient(
          135deg,
          rgba(245, 158, 11, 0.1) 0%,
          rgba(245, 158, 11, 0.05) 100%
        );
        color: #f59e0b;
      }

      .stat-icon--settings {
        background: linear-gradient(
          135deg,
          rgba(100, 116, 139, 0.1) 0%,
          rgba(100, 116, 139, 0.05) 100%
        );
        color: #64748b;
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

      /* Quick Access Cards */
      .quick-access {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: var(--space-5);
        margin-bottom: var(--space-8);
      }

      .access-card {
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

      .access-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
      }

      .access-card--students:hover {
        border-color: #3b82f6;
        box-shadow: 0 8px 24px rgba(59, 130, 246, 0.12);
      }

      .access-card--communities:hover {
        border-color: #a855f7;
        box-shadow: 0 8px 24px rgba(168, 85, 247, 0.12);
      }

      .access-card--moderators:hover {
        border-color: #f59e0b;
        box-shadow: 0 8px 24px rgba(245, 158, 11, 0.12);
      }

      .access-card--settings:hover {
        border-color: #64748b;
        box-shadow: 0 8px 24px rgba(100, 116, 139, 0.12);
      }

      .access-icon {
        width: 56px;
        height: 56px;
        margin: 0 auto var(--space-4);
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: var(--radius-lg);
      }

      .access-icon i {
        width: 28px;
        height: 28px;
      }

      .access-icon--students {
        background: linear-gradient(
          135deg,
          rgba(59, 130, 246, 0.1) 0%,
          rgba(59, 130, 246, 0.05) 100%
        );
        color: #3b82f6;
      }

      .access-icon--communities {
        background: linear-gradient(
          135deg,
          rgba(168, 85, 247, 0.1) 0%,
          rgba(168, 85, 247, 0.05) 100%
        );
        color: #a855f7;
      }

      .access-icon--moderators {
        background: linear-gradient(
          135deg,
          rgba(245, 158, 11, 0.1) 0%,
          rgba(245, 158, 11, 0.05) 100%
        );
        color: #f59e0b;
      }

      .access-icon--settings {
        background: linear-gradient(
          135deg,
          rgba(100, 116, 139, 0.1) 0%,
          rgba(100, 116, 139, 0.05) 100%
        );
        color: #64748b;
      }

      .access-card h3 {
        font-size: var(--fs-base);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-2) 0;
      }

      .access-card p {
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
          rgba(59, 130, 246, 0.02) 100%
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
        color: #3b82f6;
      }

      .section-link {
        font-size: var(--fs-sm);
        font-weight: 600;
        color: #3b82f6;
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

      .activity-icon--new {
        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        color: white;
      }

      .activity-icon--update {
        background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%);
        color: white;
      }

      .activity-icon--warning {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
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

      /* Recent Users */
      .user-item {
        display: flex;
        align-items: center;
        gap: var(--space-4);
        padding: var(--space-4);
        background: var(--color-surface);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-3);
        transition: all 0.2s ease;
      }

      .user-item:hover {
        background: rgba(59, 130, 246, 0.05);
        transform: translateX(4px);
      }

      .user-item:last-child {
        margin-bottom: 0;
      }

      .user-avatar {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: var(--fs-sm);
        flex-shrink: 0;
      }

      .user-info {
        flex: 1;
      }

      .user-name {
        font-size: var(--fs-sm);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-1) 0;
      }

      .user-meta {
        font-size: var(--fs-xs);
        color: var(--color-text-muted);
        display: flex;
        align-items: center;
        gap: var(--space-2);
      }

      .user-badge {
        display: inline-flex;
        padding: var(--space-1) var(--space-2);
        background: rgba(59, 130, 246, 0.1);
        color: #3b82f6;
        border-radius: var(--radius-sm);
        font-size: var(--fs-xs);
        font-weight: 600;
      }

      /* Community List */
      .community-item {
        display: flex;
        align-items: center;
        gap: var(--space-4);
        padding: var(--space-4);
        background: var(--color-surface);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-3);
        transition: all 0.2s ease;
      }

      .community-item:hover {
        background: rgba(168, 85, 247, 0.05);
        transform: translateX(4px);
      }

      .community-item:last-child {
        margin-bottom: 0;
      }

      .community-icon {
        width: 48px;
        height: 48px;
        border-radius: var(--radius-lg);
        background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        flex-shrink: 0;
      }

      .community-icon i {
        width: 24px;
        height: 24px;
      }

      .community-info {
        flex: 1;
      }

      .community-name {
        font-size: var(--fs-sm);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-1) 0;
      }

      .community-stats {
        font-size: var(--fs-xs);
        color: var(--color-text-muted);
        display: flex;
        align-items: center;
        gap: var(--space-3);
      }

      .community-stat {
        display: flex;
        align-items: center;
        gap: var(--space-1);
      }

      .community-stat i {
        width: 12px;
        height: 12px;
      }

      /* Full Width Section */
      .section-full {
        grid-column: 1 / -1;
      }

      /* System Status */
      .status-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: var(--space-4);
      }

      .status-item {
        padding: var(--space-4);
        background: var(--color-surface);
        border-radius: var(--radius-lg);
        border-left: 4px solid #10b981;
      }

      .status-item--warning {
        border-left-color: #f59e0b;
      }

      .status-item--error {
        border-left-color: #ef4444;
      }

      .status-label {
        font-size: var(--fs-xs);
        color: var(--color-text-muted);
        margin-bottom: var(--space-2);
        text-transform: uppercase;
        letter-spacing: 0.05em;
      }

      .status-value {
        font-size: var(--fs-xl);
        font-weight: 700;
        color: var(--color-text);
        display: flex;
        align-items: center;
        gap: var(--space-2);
      }

      .status-icon {
        width: 20px;
        height: 20px;
        color: #10b981;
      }

      .status-item--warning .status-icon {
        color: #f59e0b;
      }

      .status-item--error .status-icon {
        color: #ef4444;
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

        .quick-access {
          grid-template-columns: 1fr;
        }

        .section-header {
          flex-direction: column;
          align-items: flex-start;
          gap: var(--space-3);
        }
      }
    </style>

  <div class="dashboard-container">
          <!-- Welcome Section -->
          <div class="welcome-section">
            <div class="welcome-content">
              <h1 class="welcome-greetng">Welcome to Admin Dashboard 👋</h1>
              <p class="welcome-message">
                Manage your platform, monitor activities, and keep everything
                running smoothly.
              </p>
            </div>
          </div>

          <!-- Stats Grid -->
          <div class="stats-grid">
            <a href="${pageContext.request.contextPath}/admin/students" class="stat-card">
              <div class="stat-icon stat-icon--students">
                <i data-lucide="users"></i>
              </div>
              <div class="stat-content">
                <p class="stat-label">Total Students</p>
                <h3 class="stat-value">1,284</h3>
                <div class="stat-change stat-change--up">
                  <i data-lucide="trending-up"></i>
                  <span>+42 this week</span>
                </div>
              </div>
            </a>

            <a href="${pageContext.request.contextPath}/admin/communities" class="stat-card">
              <div class="stat-icon stat-icon--communities">
                <i data-lucide="building"></i>
              </div>
              <div class="stat-content">
                <p class="stat-label">Active Communities</p>
                <h3 class="stat-value">28</h3>
                <div class="stat-change stat-change--up">
                  <i data-lucide="trending-up"></i>
                  <span>+3 this month</span>
                </div>
              </div>
            </a>

            <a href="${pageContext.request.contextPath}/admin/moderators" class="stat-card">
              <div class="stat-icon stat-icon--moderators">
                <i data-lucide="shield"></i>
              </div>
              <div class="stat-content">
                <p class="stat-label">Active Moderators</p>
                <h3 class="stat-value">15</h3>
                <div class="stat-change stat-change--up">
                  <i data-lucide="trending-up"></i>
                  <span>+2 this month</span>
                </div>
              </div>
            </a>

            <a href="${pageContext.request.contextPath}/profile-settings" class="stat-card">
              <div class="stat-icon stat-icon--settings">
                <i data-lucide="activity"></i>
              </div>
              <div class="stat-content">
                <p class="stat-label">System Health</p>
                <h3 class="stat-value">98%</h3>
                <div class="stat-change stat-change--up">
                  <i data-lucide="trending-up"></i>
                  <span>All systems operational</span>
                </div>
              </div>
            </a>
          </div>

          <!-- Quick Access -->
          <div class="quick-access">
            <a href="${pageContext.request.contextPath}/admin/students" class="access-card access-card--students">
              <div class="access-icon access-icon--students">
                <i data-lucide="users"></i>
              </div>
              <h3>Students</h3>
              <p>Manage student accounts</p>
            </a>

            <a
              href="${pageContext.request.contextPath}/admin/communities"
              class="access-card access-card--communities"
            >
              <div class="access-icon access-icon--communities">
                <i data-lucide="building"></i>
              </div>
              <h3>Communities</h3>
              <p>Manage all communities</p>
            </a>

            <a href="${pageContext.request.contextPath}/admin/moderators" class="access-card access-card--moderators">
              <div class="access-icon access-icon--moderators">
                <i data-lucide="shield"></i>
              </div>
              <h3>Moderators</h3>
              <p>Assign and manage moderators</p>
            </a>

            <a
              href="${pageContext.request.contextPath}/profile-settings"
              class="access-card access-card--settings"
            >
              <div class="access-icon access-icon--settings">
                <i data-lucide="settings"></i>
              </div>
              <h3>Settings</h3>
              <p>Configure system settings</p>
            </a>
          </div>

          <!-- Main Grid Layout -->
          <div class="dashboard-grid">
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
                  <div class="activity-icon activity-icon--new">
                    <i data-lucide="user-plus"></i>
                  </div>
                  <div class="activity-content">
                    <p class="activity-text">
                      New student registered: <strong>Tharindu Fernando</strong>
                    </p>
                    <p class="activity-time">5 minutes ago</p>
                  </div>
                </div>

                <div class="activity-item">
                  <div class="activity-icon activity-icon--update">
                    <i data-lucide="edit"></i>
                  </div>
                  <div class="activity-content">
                    <p class="activity-text">
                      Community updated:
                      <strong>Computer Science & Engineering</strong>
                    </p>
                    <p class="activity-time">1 hour ago</p>
                  </div>
                </div>

                <div class="activity-item">
                  <div class="activity-icon activity-icon--new">
                    <i data-lucide="shield-check"></i>
                  </div>
                  <div class="activity-content">
                    <p class="activity-text">
                      New moderator assigned: <strong>Kavindu Perera</strong>
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
                      System backup completed successfully
                    </p>
                    <p class="activity-time">3 hours ago</p>
                  </div>
                </div>

                <div class="activity-item">
                  <div class="activity-icon activity-icon--new">
                    <i data-lucide="building"></i>
                  </div>
                  <div class="activity-content">
                    <p class="activity-text">
                      New community created:
                      <strong>Mechanical Engineering</strong>
                    </p>
                    <p class="activity-time">5 hours ago</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Recent Students -->
            <div class="section-card">
              <div class="section-header">
                <h2 class="section-title">
                  <i data-lucide="users"></i>
                  Recent Students
                </h2>
                <a href="${pageContext.request.contextPath}/admin/students" class="section-link">
                  View All
                  <i data-lucide="arrow-right"></i>
                </a>
              </div>
              <div class="section-body">
                <div class="user-item">
                  <div class="user-avatar">TF</div>
                  <div class="user-info">
                    <h4 class="user-name">Tharindu Fernando</h4>
                    <div class="user-meta">Joined 5 minutes ago</div>
                  </div>
                  <span class="user-badge">Active</span>
                </div>

                <div class="user-item">
                  <div class="user-avatar">NS</div>
                  <div class="user-info">
                    <h4 class="user-name">Nuwan Silva</h4>
                    <div class="user-meta">Joined 1 hour ago</div>
                  </div>
                  <span class="user-badge">Active</span>
                </div>

                <div class="user-item">
                  <div class="user-avatar">HU</div>
                  <div class="user-info">
                    <h4 class="user-name">Hashen Udara</h4>
                    <div class="user-meta">Joined 2 hours ago</div>
                  </div>
                  <span class="user-badge">Active</span>
                </div>

                <div class="user-item">
                  <div class="user-avatar">KP</div>
                  <div class="user-info">
                    <h4 class="user-name">Kasun Perera</h4>
                    <div class="user-meta">Joined 3 hours ago</div>
                  </div>
                  <span class="user-badge">Active</span>
                </div>
              </div>
            </div>

            <!-- Active Communities -->
            <div class="section-card">
              <div class="section-header">
                <h2 class="section-title">
                  <i data-lucide="building"></i>
                  Top Communities
                </h2>
                <a href="${pageContext.request.contextPath}/admin/communities" class="section-link">
                  View All
                  <i data-lucide="arrow-right"></i>
                </a>
              </div>
              <div class="section-body">
                <div class="community-item">
                  <div class="community-icon">
                    <i data-lucide="cpu"></i>
                  </div>
                  <div class="community-info">
                    <h4 class="community-name">
                      Computer Science & Engineering
                    </h4>
                    <div class="community-stats">
                      <span class="community-stat">
                        <i data-lucide="users"></i>
                        342 members
                      </span>
                      <span class="community-stat">
                        <i data-lucide="message-square"></i>
                        128 posts
                      </span>
                    </div>
                  </div>
                </div>

                <div class="community-item">
                  <div class="community-icon">
                    <i data-lucide="cog"></i>
                  </div>
                  <div class="community-info">
                    <h4 class="community-name">Mechanical Engineering</h4>
                    <div class="community-stats">
                      <span class="community-stat">
                        <i data-lucide="users"></i>
                        256 members
                      </span>
                      <span class="community-stat">
                        <i data-lucide="message-square"></i>
                        89 posts
                      </span>
                    </div>
                  </div>
                </div>

                <div class="community-item">
                  <div class="community-icon">
                    <i data-lucide="zap"></i>
                  </div>
                  <div class="community-info">
                    <h4 class="community-name">Electrical Engineering</h4>
                    <div class="community-stats">
                      <span class="community-stat">
                        <i data-lucide="users"></i>
                        198 members
                      </span>
                      <span class="community-stat">
                        <i data-lucide="message-square"></i>
                        64 posts
                      </span>
                    </div>
                  </div>
                </div>

                <div class="community-item">
                  <div class="community-icon">
                    <i data-lucide="flask"></i>
                  </div>
                  <div class="community-info">
                    <h4 class="community-name">Chemical Engineering</h4>
                    <div class="community-stats">
                      <span class="community-stat">
                        <i data-lucide="users"></i>
                        145 members
                      </span>
                      <span class="community-stat">
                        <i data-lucide="message-square"></i>
                        42 posts
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
v>
          </div>
        </div>

         <script>
      document.addEventListener("DOMContentLoaded", function () {
        if (window.lucide) window.lucide.createIcons();

        // Get current hour for personalized greeting
        const hour = new Date().getHours();
        let greeting = "Welcome to Admin Dashboard";

        if (hour < 12) {
          greeting = "Good morning, Admin";
        } else if (hour < 18) {
          greeting = "Good afternoon, Admin";
        } else {
          greeting = "Good evening, Admin";
        }

        // Update greeting
        const greetingElement = document.querySelector(".welcome-greeting");
        if (greetingElement) {
          greetingElement.textContent = `${greeting} 👋`;
        }
      });
    </script>
</layout:admin-dashboard>
