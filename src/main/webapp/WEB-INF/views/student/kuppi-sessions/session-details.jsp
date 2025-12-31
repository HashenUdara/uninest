<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Kuppi Sessions" activePage="kuppi-sessions">
         <link rel="stylesheet" href="${pageContext.request.contextPath}/static/community.css" />
     
      <style>
      /* Layout */
      .k-detail-layout {
        display: grid;
        grid-template-columns: 1fr 350px;
        gap: var(--space-6);
        align-items: start;
      }

      /* Main Content */
      .k-detail-main {
        display: flex;
        flex-direction: column;
        gap: var(--space-6);
      }

      /* Hero Section */
      .k-detail-hero {
        background: linear-gradient(
          135deg,
          var(--color-brand) 0%,
          #6b50f5 100%
        );
        border-radius: var(--radius-lg);
        padding: var(--space-8);
        color: white;
        position: relative;
        overflow: hidden;
      }

      .k-detail-hero::before {
        content: "";
        position: absolute;
        top: -50%;
        right: -10%;
        width: 500px;
        height: 500px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 50%;
      }

      .k-detail-hero__content {
        position: relative;
        z-index: 1;
      }

      .k-detail-hero__badge {
        display: inline-flex;
        align-items: center;
        gap: var(--space-2);
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(10px);
        padding: var(--space-2) var(--space-4);
        border-radius: var(--radius-pill);
        font-size: var(--fs-sm);
        font-weight: 600;
        margin-bottom: var(--space-4);
      }

      .k-detail-hero__badge i {
        width: 16px;
        height: 16px;
      }

      .k-detail-hero__title {
        font-size: 2rem;
        font-weight: 700;
        margin: 0 0 var(--space-4) 0;
        line-height: 1.2;
      }

      .k-detail-hero__meta {
        display: flex;
        align-items: center;
        gap: var(--space-5);
        flex-wrap: wrap;
        font-size: var(--fs-base);
        opacity: 0.95;
      }

      .k-detail-hero__meta-item {
        display: flex;
        align-items: center;
        gap: var(--space-2);
      }

      .k-detail-hero__meta-item i {
        width: 20px;
        height: 20px;
      }

      /* Info Card */
      .k-info-card {
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: var(--space-6);
      }

      .k-info-card__title {
        font-size: var(--fs-lg);
        font-weight: 700;
        color: var(--color-text);
        margin: 0 0 var(--space-4) 0;
        display: flex;
        align-items: center;
        gap: var(--space-2);
      }

      .k-info-card__title i {
        width: 20px;
        height: 20px;
        color: var(--color-brand);
      }

      .k-info-card__text {
        color: var(--color-text);
        line-height: 1.7;
        font-size: var(--fs-base);
        margin: 0;
      }

      /* Conductor Section */
      .k-conductor-section {
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: var(--space-6);
      }

      .k-conductor-section__title {
        font-size: var(--fs-lg);
        font-weight: 700;
        color: var(--color-text);
        margin: 0 0 var(--space-5) 0;
      }

      .k-conductor-profile {
        display: flex;
        gap: var(--space-4);
        align-items: start;
        padding: var(--space-5);
        background: var(--color-surface);
        border-radius: var(--radius-md);
      }

      .k-conductor-profile__avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid var(--color-white);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      }

      .k-conductor-profile__info {
        flex: 1;
      }

      .k-conductor-profile__header {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        margin-bottom: var(--space-2);
      }

      .k-conductor-profile__name {
        font-size: var(--fs-lg);
        font-weight: 700;
        color: var(--color-text);
        margin: 0;
      }

      .k-conductor-profile__badge {
        display: inline-flex;
        align-items: center;
        gap: var(--space-1);
        background: var(--color-brand-soft);
        color: var(--color-brand);
        padding: var(--space-1) var(--space-2);
        border-radius: var(--radius-pill);
        font-size: var(--fs-xs);
        font-weight: 700;
      }

      .k-conductor-profile__badge i {
        width: 12px;
        height: 12px;
      }

      .k-conductor-profile__bio {
        color: var(--color-text-muted);
        line-height: 1.6;
        margin: 0 0 var(--space-3) 0;
      }

      .k-conductor-profile__stats {
        display: flex;
        gap: var(--space-4);
        font-size: var(--fs-sm);
      }

      .k-conductor-profile__stat {
        display: flex;
        align-items: center;
        gap: var(--space-1);
        color: var(--color-text-muted);
      }

      .k-conductor-profile__stat i {
        width: 14px;
        height: 14px;
      }

      /* Attendees */
      .k-attendees {
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: var(--space-6);
      }

      .k-attendees__header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: var(--space-4);
      }

      .k-attendees__title {
        font-size: var(--fs-lg);
        font-weight: 700;
        color: var(--color-text);
        margin: 0;
      }

      .k-attendees__count {
        background: var(--color-brand-soft);
        color: var(--color-brand);
        padding: var(--space-1) var(--space-3);
        border-radius: var(--radius-pill);
        font-size: var(--fs-sm);
        font-weight: 700;
      }

      .k-attendees__grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: var(--space-3);
      }

      .k-attendee {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        padding: var(--space-2);
        background: var(--color-surface);
        border-radius: var(--radius-md);
        font-size: var(--fs-sm);
      }

      .k-attendee__avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        object-fit: cover;
      }

      .k-attendee__name {
        color: var(--color-text);
        font-weight: 500;
      }

      /* Sidebar */
      .k-sidebar {
        display: flex;
        flex-direction: column;
        gap: var(--space-5);
        position: sticky;
        top: var(--space-6);
      }

      .k-sidebar-card {
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: var(--space-5);
      }

      .k-sidebar-card__title {
        font-size: var(--fs-base);
        font-weight: 700;
        color: var(--color-text);
        margin: 0 0 var(--space-4) 0;
      }

      /* Session Details */
      .k-session-details {
        display: flex;
        flex-direction: column;
        gap: var(--space-3);
      }

      .k-session-detail {
        display: flex;
        gap: var(--space-3);
        padding: var(--space-3);
        background: var(--color-surface);
        border-radius: var(--radius-md);
      }

      .k-session-detail__icon {
        width: 40px;
        height: 40px;
        border-radius: var(--radius-md);
        background: var(--color-brand-soft);
        color: var(--color-brand);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
      }

      .k-session-detail__icon i {
        width: 20px;
        height: 20px;
      }

      .k-session-detail__content {
        flex: 1;
      }

      .k-session-detail__label {
        font-size: var(--fs-xs);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: var(--color-text-muted);
        font-weight: 600;
        margin: 0 0 var(--space-1) 0;
      }

      .k-session-detail__value {
        font-size: var(--fs-base);
        font-weight: 600;
        color: var(--color-text);
        margin: 0;
      }

      /* Actions */
      .k-sidebar-card__actions {
        display: flex;
        flex-direction: column;
        gap: var(--space-2);
      }

      /* Alert Box */
      .k-alert {
        background: var(--color-success-soft);
        border: 1px solid var(--color-success);
        border-radius: var(--radius-md);
        padding: var(--space-4);
        display: flex;
        gap: var(--space-3);
        margin-bottom: var(--space-5);
      }

      .k-alert__icon {
        width: 20px;
        height: 20px;
        color: var(--color-success);
        flex-shrink: 0;
        margin-top: 2px;
      }

      .k-alert__content {
        flex: 1;
      }

      .k-alert__title {
        font-size: var(--fs-sm);
        font-weight: 700;
        color: var(--color-success);
        margin: 0 0 var(--space-1) 0;
      }

      .k-alert__text {
        font-size: var(--fs-sm);
        color: var(--color-text);
        margin: 0;
        line-height: 1.5;
      }

      @media (max-width: 968px) {
        .k-detail-layout {
          grid-template-columns: 1fr;
        }

        .k-sidebar {
          position: static;
        }

        .k-detail-hero {
          padding: var(--space-6);
        }

        .k-detail-hero__title {
          font-size: 1.5rem;
        }
      }
    </style>
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/student/kuppi-sessions">Kuppi Sessions </a>
            <span class="c-breadcrumbs__sep">/</span>
            <span aria-current="page">Session Details</span>
        </nav>
        <div
            style="
              display: flex;
              justify-content: space-between;
              align-items: center;
              gap: var(--space-4);
            "
          >
            <div>
              <h1 class="c-page__title">Scheduled Session Details</h1>
              <p class="c-page__subtitle u-text-muted">
                View and join upcoming Kuppi sessions with confirmed conductors
              </p>
            </div>
            <a href="${pageContext.request.contextPath}/student/kuppi-sessions" class="c-btn c-btn--ghost"
              ><i data-lucide="arrow-left"></i> Back to Schedule</a
            >
          </div>
          
        
    </header>

    <c:if test="${not empty error}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>${error}</p>
        </div>
    </c:if>

  <div class="k-detail-layout">
          <!-- Main Content -->
          <div class="k-detail-main">
            <!-- Hero Section -->
            <div class="k-detail-hero">
              <div class="k-detail-hero__content">
                <div class="k-detail-hero__badge">
                  <i data-lucide="zap"></i>
                  Starting Today at 4:00 PM
                </div>
                <h2 class="k-detail-hero__title">
                  Binary Search Trees and Traversal Techniques
                </h2>
                <div class="k-detail-hero__meta">
                  <div class="k-detail-hero__meta-item">
                    <i data-lucide="book"></i>
                    <span>CS204 - Data Structures</span>
                  </div>
                  <div class="k-detail-hero__meta-item">
                    <i data-lucide="video"></i>
                    <span>Online via Zoom</span>
                  </div>
                  <div class="k-detail-hero__meta-item">
                    <i data-lucide="timer"></i>
                    <span>2 hours</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Alert -->
            <div class="k-alert">
              <i data-lucide="check-circle" class="k-alert__icon"></i>
              <div class="k-alert__content">
                <h3 class="k-alert__title">You're Registered!</h3>
                <p class="k-alert__text">
                  You're all set for this session. A calendar invite and Zoom
                  meeting link have been sent to your email.
                </p>
              </div>
            </div>

            <!-- About Session -->
            <div class="k-info-card">
              <h3 class="k-info-card__title">
                <i data-lucide="file-text"></i>
                About This Session
              </h3>
              <p class="k-info-card__text">
                Let's deep dive into Binary Search Trees, covering insertion,
                deletion, and various traversal methods (inorder, preorder,
                postorder). Perfect for anyone preparing for the midterm exam.
                We'll work through practice problems together and discuss common
                interview questions related to BST implementations. Bring your
                laptops and be ready to code along!
              </p>
            </div>

            <!-- Conductor Section -->
            <div class="k-conductor-section">
              <h3 class="k-conductor-section__title">Your Conductor</h3>
              <div class="k-conductor-profile">
                <img
                  src="https://i.pravatar.cc/150?img=56"
                  alt="Priya Sharma"
                  class="k-conductor-profile__avatar"
                />
                <div class="k-conductor-profile__info">
                  <div class="k-conductor-profile__header">
                    <h4 class="k-conductor-profile__name">Priya Sharma</h4>
                    <span class="k-conductor-profile__badge">
                      <i data-lucide="star"></i>
                      Top Rated
                    </span>
                  </div>
                  <p class="k-conductor-profile__bio">
                    3rd year CS student. TA for Data Structures. Love teaching
                    algorithms and helping students understand complex concepts
                    through practical examples!
                  </p>
                  <div class="k-conductor-profile__stats">
                    <div class="k-conductor-profile__stat">
                      <i data-lucide="award"></i>
                      <span>24 sessions conducted</span>
                    </div>
                    <div class="k-conductor-profile__stat">
                      <i data-lucide="star"></i>
                      <span>4.9 rating</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Attendees -->
            <div class="k-attendees">
              <div class="k-attendees__header">
                <h3 class="k-attendees__title">Who's Attending</h3>
                <span class="k-attendees__count">32 Students</span>
              </div>
              <div class="k-attendees__grid">
                <div class="k-attendee">
                  <img
                    src="https://i.pravatar.cc/150?img=12"
                    alt="Kasun Perera"
                    class="k-attendee__avatar"
                  />
                  <span class="k-attendee__name">Kasun Perera</span>
                </div>
                <div class="k-attendee">
                  <img
                    src="https://i.pravatar.cc/150?img=45"
                    alt="Nimali Fernando"
                    class="k-attendee__avatar"
                  />
                  <span class="k-attendee__name">Nimali Fernando</span>
                </div>
                <div class="k-attendee">
                  <img
                    src="https://i.pravatar.cc/150?img=33"
                    alt="Tharindu Silva"
                    class="k-attendee__avatar"
                  />
                  <span class="k-attendee__name">Tharindu Silva</span>
                </div>
                <div class="k-attendee">
                  <img
                    src="https://i.pravatar.cc/150?img=23"
                    alt="Dilini Jayasinghe"
                    class="k-attendee__avatar"
                  />
                  <span class="k-attendee__name">Dilini Jayasinghe</span>
                </div>
                <div class="k-attendee">
                  <img
                    src="https://i.pravatar.cc/150?img=68"
                    alt="Ravindu Wickramasinghe"
                    class="k-attendee__avatar"
                  />
                  <span class="k-attendee__name">Ravindu W.</span>
                </div>
                <div class="k-attendee">
                  <img
                    src="https://i.pravatar.cc/150?img=52"
                    alt="Lahiru Fernando"
                    class="k-attendee__avatar"
                  />
                  <span class="k-attendee__name">Lahiru Fernando</span>
                </div>
                <div class="k-attendee">
                  <img
                    src="https://i.pravatar.cc/150?img=41"
                    alt="Sanduni Perera"
                    class="k-attendee__avatar"
                  />
                  <span class="k-attendee__name">Sanduni Perera</span>
                </div>
                <div class="k-attendee">
                  <img
                    src="https://i.pravatar.cc/150?img=22"
                    alt="Nimal Jayasinghe"
                    class="k-attendee__avatar"
                  />
                  <span class="k-attendee__name">Nimal Jayasinghe</span>
                </div>
                <div class="k-attendee">
                  <span
                    style="
                      display: inline-flex;
                      align-items: center;
                      justify-content: center;
                      width: 32px;
                      height: 32px;
                      border-radius: 50%;
                      background: var(--color-brand-soft);
                      color: var(--color-brand);
                      font-size: var(--fs-xs);
                      font-weight: 700;
                    "
                    >+24</span
                  >
                  <span class="k-attendee__name">more students</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Sidebar -->
          <aside class="k-sidebar">
            <!-- Session Details -->
            <div class="k-sidebar-card">
              <h3 class="k-sidebar-card__title">Session Details</h3>
              <div class="k-session-details">
                <div class="k-session-detail">
                  <div class="k-session-detail__icon">
                    <i data-lucide="calendar"></i>
                  </div>
                  <div class="k-session-detail__content">
                    <p class="k-session-detail__label">Date</p>
                    <p class="k-session-detail__value">October 23, 2025</p>
                  </div>
                </div>

                <div class="k-session-detail">
                  <div class="k-session-detail__icon">
                    <i data-lucide="clock"></i>
                  </div>
                  <div class="k-session-detail__content">
                    <p class="k-session-detail__label">Time</p>
                    <p class="k-session-detail__value">4:00 PM - 6:00 PM</p>
                  </div>
                </div>

                <div class="k-session-detail">
                  <div class="k-session-detail__icon">
                    <i data-lucide="video"></i>
                  </div>
                  <div class="k-session-detail__content">
                    <p class="k-session-detail__label">Platform</p>
                    <p class="k-session-detail__value">Zoom Meeting</p>
                  </div>
                </div>

                <div class="k-session-detail">
                  <div class="k-session-detail__icon">
                    <i data-lucide="users"></i>
                  </div>
                  <div class="k-session-detail__content">
                    <p class="k-session-detail__label">Capacity</p>
                    <p class="k-session-detail__value">32 / 50 students</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Quick Actions -->
            <div class="k-sidebar-card">
              <h3 class="k-sidebar-card__title">Quick Actions</h3>
              <div class="k-sidebar-card__actions">
                <button class="c-btn">
                  <i data-lucide="video"></i> Get Meeting Link
                </button>
                <button class="c-btn c-btn--ghost">
                  <i data-lucide="calendar-plus"></i> Add to Calendar
                </button>
                <button class="c-btn c-btn--ghost">
                  <i data-lucide="share-2"></i> Share Session
                </button>
                <button class="c-btn c-btn--ghost">
                  <i data-lucide="message-circle"></i> Ask Questions
                </button>
                <button
                  class="c-btn c-btn--ghost"
                  style="color: var(--color-danger)"
                >
                  <i data-lucide="x-circle"></i> Cancel Registration
                </button>
              </div>
            </div>

            <!-- Resources -->
            <div class="k-sidebar-card">
              <h3 class="k-sidebar-card__title">Session Materials</h3>
              <p
                style="
                  font-size: var(--fs-sm);
                  color: var(--color-text-muted);
                  margin: 0;
                "
              >
                Materials will be shared by the conductor before the session
                starts. Check back later!
              </p>
            </div>
          </aside>
        </div>

    <!-- Toast Container -->
    <div class="c-toasts" aria-live="polite"></div>

    <script>
      document.addEventListener("DOMContentLoaded", function () {
        if (window.lucide) window.lucide.createIcons();

        const toasts = document.querySelector(".c-toasts");

        // Action buttons
        document
          .querySelector('button:has([data-lucide="video"])')
          .addEventListener("click", () => {
            showToast("Meeting link copied to clipboard!");
          });

        document
          .querySelector('button:has([data-lucide="calendar-plus"])')
          .addEventListener("click", () => {
            showToast("Calendar event created!");
          });

        document
          .querySelector('button:has([data-lucide="share-2"])')
          .addEventListener("click", () => {
            showToast("Share link copied to clipboard!");
          });

        document
          .querySelector('button:has([data-lucide="message-circle"])')
          .addEventListener("click", () => {
            showToast("Opening discussion...");
          });

        document
          .querySelector('button:has([data-lucide="x-circle"])')
          .addEventListener("click", () => {
            if (confirm("Are you sure you want to cancel your registration?")) {
              showToast("Registration cancelled");
              setTimeout(() => {
                window.location.href = "kuppi-scheduled.html";
              }, 1500);
            }
          });

        // Toast notification
        function showToast(msg) {
          if (!toasts) return;
          const item = document.createElement("div");
          item.className = "c-toast";
          item.textContent = msg;
          toasts.appendChild(item);
          setTimeout(() => {
            item.remove();
          }, 3000);
        }
      });
    </script>
       
</layout:student-dashboard>
