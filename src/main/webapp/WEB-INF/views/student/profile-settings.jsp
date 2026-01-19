<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Profile Settings" activePage="profile-settings">
         <link rel="stylesheet" href="${pageContext.request.contextPath}/static/community.css" />
     
      <style>
      .k-settings-container {
        max-width: 1200px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: 280px 1fr;
        gap: var(--space-6);
        align-items: start;
      }

      .k-settings-nav {
        position: sticky;
        top: var(--space-6);
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: var(--space-5);
      }

      .k-settings-nav__title {
        font-size: var(--fs-xs);
        font-weight: 600;
        color: var(--color-text-muted);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin: 0 0 var(--space-3) 0;
        padding: 0 var(--space-3);
      }

      .k-settings-nav__list {
        list-style: none;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        gap: var(--space-1);
      }

      .k-settings-nav__item {
        display: flex;
        align-items: center;
        gap: var(--space-3);
        padding: var(--space-3) var(--space-3);
        border-radius: var(--radius-md);
        color: var(--color-text-muted);
        font-size: var(--fs-sm);
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
        text-decoration: none;
      }

      .k-settings-nav__item:hover {
        background: var(--color-surface);
        color: var(--color-text);
      }

      .k-settings-nav__item.is-active {
        background: rgba(84, 44, 245, 0.08);
        color: var(--color-brand);
        font-weight: 600;
      }

      .k-settings-nav__item i {
        width: 18px;
        height: 18px;
      }

      .k-settings-content {
        display: flex;
        flex-direction: column;
        gap: var(--space-6);
      }

      .k-settings-section {
        display: none;
      }

      .k-settings-section.is-active {
        display: block;
      }

      .k-settings-card {
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: var(--space-6);
      }

      .k-settings-card__header {
        margin-bottom: var(--space-5);
      }

      .k-settings-card__title {
        font-size: var(--fs-lg);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-1) 0;
      }

      .k-settings-card__subtitle {
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
        margin: 0;
      }

      .k-profile-header {
        display: flex;
        align-items: center;
        gap: var(--space-5);
        padding: var(--space-6);
        background: var(--color-white);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-6);
      }

      .k-profile-avatar {
        position: relative;
      }

      .k-profile-avatar__image {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid var(--color-border);
      }

      .k-profile-avatar__edit {
        position: absolute;
        bottom: 0;
        right: 0;
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: var(--color-brand);
        color: white;
        border: 2px solid var(--color-white);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: background 0.2s ease;
      }

      .k-profile-avatar__edit:hover {
        background: var(--color-brand-dark);
      }

      .k-profile-avatar__edit i {
        width: 14px;
        height: 14px;
      }

      .k-profile-info h2 {
        font-size: var(--fs-xl);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-1) 0;
      }

      .k-profile-meta {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        font-size: var(--fs-sm);
        color: var(--color-text-muted);
      }

      .k-profile-meta__item {
        display: flex;
        align-items: center;
        gap: var(--space-2);
      }

      .k-profile-meta__item i {
        width: 14px;
        height: 14px;
      }

      .k-form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: var(--space-5);
      }

      .k-form-grid--full {
        grid-column: 1 / -1;
      }

      .k-toggle-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: var(--space-4);
        background: var(--color-surface);
        border-radius: var(--radius-md);
        margin-bottom: var(--space-3);
        transition: background 0.2s ease;
      }

      .k-toggle-item:hover {
        background: var(--color-border);
      }

      .k-toggle-item__content {
        flex: 1;
      }

      .k-toggle-item__title {
        font-size: var(--fs-sm);
        font-weight: 600;
        color: var(--color-text);
        margin: 0 0 var(--space-1) 0;
      }

      .k-toggle-item__desc {
        font-size: var(--fs-xs);
        color: var(--color-text-muted);
        margin: 0;
        line-height: 1.5;
      }

      .k-toggle-switch {
        position: relative;
        width: 48px;
        height: 28px;
        flex-shrink: 0;
      }

      .k-toggle-switch input {
        position: absolute;
        opacity: 0;
        width: 0;
        height: 0;
      }

      .k-toggle-switch__slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: var(--color-border);
        transition: 0.3s;
        border-radius: 34px;
      }

      .k-toggle-switch__slider:before {
        position: absolute;
        content: "";
        height: 20px;
        width: 20px;
        left: 4px;
        bottom: 4px;
        background: white;
        transition: 0.3s;
        border-radius: 50%;
      }

      .k-toggle-switch input:checked + .k-toggle-switch__slider {
        background: var(--color-brand);
      }

      .k-toggle-switch input:checked + .k-toggle-switch__slider:before {
        transform: translateX(20px);
      }

      .k-form-actions {
        display: flex;
        gap: var(--space-3);
        justify-content: flex-end;
        margin-top: var(--space-5);
      }

      @media (max-width: 768px) {
        .k-settings-container {
          grid-template-columns: 1fr;
        }

        .k-settings-nav {
          position: static;
        }

        .k-settings-nav__list {
          flex-direction: row;
          overflow-x: auto;
          gap: var(--space-2);
        }

        .k-settings-nav__item {
          white-space: nowrap;
        }

        .k-form-grid {
          grid-template-columns: 1fr;
        }

        .k-profile-header {
          flex-direction: column;
          text-align: center;
        }

        .k-profile-meta {
          flex-direction: column;
          gap: var(--space-2);
        }
      }
    </style>
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/student/resources">Profile Settings</a>
            <span class="c-breadcrumbs__sep">/</span>
            <span aria-current="page">Edit Resource</span>
        </nav>
       <div>
            <h1 class="c-page__title">Settings</h1>
            <p class="c-page__subtitle u-text-muted">
              Manage your account settings and preferences.
            </p>
          </div>
       
    </header>

    <c:if test="${not empty error}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>${error}</p>
        </div>
    </c:if>

  <div class="k-settings-container">
          <!-- Settings Navigation -->
          <nav class="k-settings-nav">
            <h3 class="k-settings-nav__title">Settings</h3>
            <ul class="k-settings-nav__list">
              <li>
                <a
                  href="#"
                  class="k-settings-nav__item is-active"
                  data-section="profile"
                >
                  <i data-lucide="user"></i>
                  Profile
                </a>
              </li>
              <li>
                <a href="#" class="k-settings-nav__item" data-section="account">
                  <i data-lucide="shield"></i>
                  Account
                </a>
              </li>
              <li>
                <a
                  href="#"
                  class="k-settings-nav__item"
                  data-section="notifications"
                >
                  <i data-lucide="bell"></i>
                  Notifications
                </a>
              </li>
              <li>
                <a href="#" class="k-settings-nav__item" data-section="privacy">
                  <i data-lucide="lock"></i>
                  Privacy
                </a>
              </li>
              <li>
                <a
                  href="#"
                  class="k-settings-nav__item"
                  data-section="preferences"
                >
                  <i data-lucide="sliders"></i>
                  Preferences
                </a>
              </li>
            </ul>
          </nav>

          <!-- Settings Content -->
          <div class="k-settings-content">
            <!-- Profile Section -->
            <section class="k-settings-section is-active" id="section-profile">
              <!-- Profile Header -->
              <div class="k-profile-header">
                <div class="k-profile-avatar">
                  <img
                    src="${pageContext.request.contextPath}${sessionScope.authUser.profilePictureUrl}"
                    id="profileImagePreview"
                    alt="${sessionScope.authUser.firstName} ${sessionScope.authUser.lastName}"
                    class="k-profile-avatar__image"
                  />
                  <button type="button" class="k-profile-avatar__edit" title="Change avatar" onclick="document.getElementById('profileUploadInput').click()">
                    <i data-lucide="camera"></i>
                  </button>
                  <input 
                    type="file" 
                    id="profileUploadInput" 
                    name="profileImage" 
                    accept="image/*" 
                    style="display: none;" 
                    onchange="previewImage(this)"
                    form="profileForm"
                  >
                </div>
                <div class="k-profile-info">
                  <h2>${sessionScope.authUser.firstName} ${sessionScope.authUser.lastName}</h2>
                  <div class="k-profile-meta">
                    <div class="k-profile-meta__item">
                      <i data-lucide="mail"></i>
                      ${sessionScope.authUser.email}
                    </div>
                  </div>
                </div>
              </div>

              <!-- Profile Information -->
              <div class="k-settings-card">
                <div class="k-settings-card__header">
                  <h3 class="k-settings-card__title">Profile</h3>
                  <p class="k-settings-card__subtitle">
                    Update your personal information
                  </p>
                </div>

                <form id="profileForm" action="${pageContext.request.contextPath}/student/profile-settings" method="post" enctype="multipart/form-data">
                  <div class="k-form-grid">
                    <div class="c-field">
                      <label for="first-name" class="c-label">
                        First Name <span class="u-text-danger">*</span>
                      </label>
                      <input
                        type="text"
                        id="first-name"
                        class="c-input c-input--soft c-input--rect"
                        name="firstName"
                        value="${sessionScope.authUser.firstName}"
                        required
                      />
                    </div>

                    <div class="c-field">
                      <label for="last-name" class="c-label">
                        Last Name <span class="u-text-danger">*</span>
                      </label>
                      <input
                        type="text"
                        id="last-name"
                        class="c-input c-input--soft c-input--rect"
                        name="lastName"
                        value="${sessionScope.authUser.lastName}"
                        required
                      />
                    </div>

                    <div class="c-field">
                      <label for="email" class="c-label">
                        Email <span class="u-text-danger">*</span>
                      </label>
                      <input
                        type="email"
                        id="email"
                        class="c-input c-input--soft c-input--rect"
                        value="${sessionScope.authUser.email}"
                        readonly
                      />
                    </div>

                    <div class="c-field">
                      <label for="phone" class="c-label">Phone</label>
                      <input
                        type="tel"
                        id="phone"
                        class="c-input c-input--soft c-input--rect"
                        name="phone"
                        value="${sessionScope.authUser.phoneNumber}"
                        placeholder="077 123 4567"
                        maxlength="10"
                        pattern="[0-9]{10}"
                        title="Phone number must be 10 digits"
                      />
                    </div>

                    <div class="c-field">
                      <label for="student-id" class="c-label">Student ID</label>
                      <input
                        type="text"
                        id="student-id"
                        class="c-input c-input--soft c-input--rect"
                        name="universityIdNumber"
                        value="${sessionScope.authUser.universityIdNumber}"
                        readonly
                        style="background: var(--color-surface)"
                      />
                    </div>

                    <div class="c-field">
                      <label for="year" class="c-label">Year</label>
                      <select
                        id="year"
                        class="c-input c-input--soft c-input--rect"
                        name="academicYear"
                      >
                        <option value="1" ${sessionScope.authUser.academicYear == 1 ? 'selected' : ''}>1st Year</option>
                        <option value="2" ${sessionScope.authUser.academicYear == 2 ? 'selected' : ''}>2nd Year</option>
                        <option value="3" ${sessionScope.authUser.academicYear == 3 ? 'selected' : ''}>3rd Year</option>
                        <option value="4" ${sessionScope.authUser.academicYear == 4 ? 'selected' : ''}>4th Year</option>
                      </select>
                    </div>
                  </div>

                  <div class="k-form-actions">
                    <button type="submit" class="c-btn">
                      <i data-lucide="save"></i> Save Changes
                    </button>
                  </div>
                </form>
              </div>
            </section>

            <!-- Account Section -->
            <section class="k-settings-section" id="section-account">
              <div class="k-settings-card">
                <div class="k-settings-card__header">
                  <h3 class="k-settings-card__title">Security</h3>
                  <p class="k-settings-card__subtitle">Manage your password</p>
                </div>

                <form>
                  <div class="k-form-grid">
                    <div class="c-field k-form-grid--full">
                      <label for="current-password" class="c-label">
                        Current Password <span class="u-text-danger">*</span>
                      </label>
                      <input
                        type="password"
                        id="current-password"
                        class="c-input c-input--soft c-input--rect"
                        required
                      />
                    </div>

                    <div class="c-field">
                      <label for="new-password" class="c-label">
                        New Password <span class="u-text-danger">*</span>
                      </label>
                      <input
                        type="password"
                        id="new-password"
                        class="c-input c-input--soft c-input--rect"
                        required
                      />
                    </div>

                    <div class="c-field">
                      <label for="confirm-password" class="c-label">
                        Confirm Password <span class="u-text-danger">*</span>
                      </label>
                      <input
                        type="password"
                        id="confirm-password"
                        class="c-input c-input--soft c-input--rect"
                        required
                      />
                    </div>
                  </div>

                  <div class="k-form-actions">
                    <button type="submit" class="c-btn">
                      <i data-lucide="lock"></i> Update Password
                    </button>
                  </div>
                </form>
              </div>
            </section>

            <!-- Notifications Section -->
            <section class="k-settings-section" id="section-notifications">
              <div class="k-settings-card">
                <div class="k-settings-card__header">
                  <h3 class="k-settings-card__title">Notifications</h3>
                  <p class="k-settings-card__subtitle">
                    Choose what notifications you want to receive
                  </p>
                </div>

                <div class="k-toggle-item">
                  <div class="k-toggle-item__content">
                    <h5 class="k-toggle-item__title">Kuppi Sessions</h5>
                    <p class="k-toggle-item__desc">
                      Session updates and reminders
                    </p>
                  </div>
                  <label class="k-toggle-switch">
                    <input type="checkbox" checked />
                    <span class="k-toggle-switch__slider"></span>
                  </label>
                </div>

                <div class="k-toggle-item">
                  <div class="k-toggle-item__content">
                    <h5 class="k-toggle-item__title">New Resources</h5>
                    <p class="k-toggle-item__desc">
                      When new study materials are uploaded
                    </p>
                  </div>
                  <label class="k-toggle-switch">
                    <input type="checkbox" checked />
                    <span class="k-toggle-switch__slider"></span>
                  </label>
                </div>

                <div class="k-toggle-item">
                  <div class="k-toggle-item__content">
                    <h5 class="k-toggle-item__title">Community</h5>
                    <p class="k-toggle-item__desc">
                      Replies to your posts and comments
                    </p>
                  </div>
                  <label class="k-toggle-switch">
                    <input type="checkbox" checked />
                    <span class="k-toggle-switch__slider"></span>
                  </label>
                </div>

                <div class="k-form-actions">
                  <button type="button" class="c-btn">
                    <i data-lucide="save"></i> Save
                  </button>
                </div>
              </div>
            </section>

            <!-- Privacy Section -->
            <section class="k-settings-section" id="section-privacy">
              <div class="k-settings-card">
                <div class="k-settings-card__header">
                  <h3 class="k-settings-card__title">Privacy</h3>
                  <p class="k-settings-card__subtitle">
                    Control your profile visibility
                  </p>
                </div>

                <div class="k-toggle-item">
                  <div class="k-toggle-item__content">
                    <h5 class="k-toggle-item__title">Public Profile</h5>
                    <p class="k-toggle-item__desc">
                      Allow others to view your profile
                    </p>
                  </div>
                  <label class="k-toggle-switch">
                    <input type="checkbox" checked />
                    <span class="k-toggle-switch__slider"></span>
                  </label>
                </div>

                <div class="k-toggle-item">
                  <div class="k-toggle-item__content">
                    <h5 class="k-toggle-item__title">Show Activity</h5>
                    <p class="k-toggle-item__desc">
                      Display your recent sessions and resources
                    </p>
                  </div>
                  <label class="k-toggle-switch">
                    <input type="checkbox" checked />
                    <span class="k-toggle-switch__slider"></span>
                  </label>
                </div>

                <div class="k-form-actions">
                  <button type="button" class="c-btn">
                    <i data-lucide="save"></i> Save
                  </button>
                </div>
              </div>
            </section>

            <!-- Preferences Section -->
            <section class="k-settings-section" id="section-preferences">
              <div class="k-settings-card">
                <div class="k-settings-card__header">
                  <h3 class="k-settings-card__title">Preferences</h3>
                  <p class="k-settings-card__subtitle">
                    Customize your experience
                  </p>
                </div>

                <form>
                  <div class="k-form-grid">
                    <div class="c-field">
                      <label for="theme" class="c-label">Theme</label>
                      <select
                        id="theme"
                        class="c-input c-input--soft c-input--rect"
                      >
                        <option value="light">Light</option>
                        <option value="dark">Dark</option>
                        <option value="auto">Auto</option>
                      </select>
                    </div>

                    <div class="c-field">
                      <label for="language" class="c-label">Language</label>
                      <select
                        id="language"
                        class="c-input c-input--soft c-input--rect"
                      >
                        <option value="en">English</option>
                        <option value="si">Sinhala</option>
                        <option value="ta">Tamil</option>
                      </select>
                    </div>
                  </div>

                  <div class="k-form-actions">
                    <button type="submit" class="c-btn">
                      <i data-lucide="save"></i> Save
                    </button>
                  </div>
                </form>
              </div>
            </section>
          </div>
        </div>
       
       <script>
      document.addEventListener("DOMContentLoaded", function () {
        if (window.lucide) window.lucide.createIcons();

        // Settings navigation
        const navItems = document.querySelectorAll(".k-settings-nav__item");
        const sections = document.querySelectorAll(".k-settings-section");

        navItems.forEach((item) => {
          item.addEventListener("click", function (e) {
            e.preventDefault();
            const sectionId = this.dataset.section;

            // Update active nav item
            navItems.forEach((nav) => nav.classList.remove("is-active"));
            this.classList.add("is-active");

            // Show corresponding section
            sections.forEach((section) =>
              section.classList.remove("is-active")
            );
            const targetSection = document.getElementById('section-' + sectionId);
            if (targetSection) {
              targetSection.classList.add("is-active");
            }

            // Scroll to top
            window.scrollTo({ top: 0, behavior: "smooth" });
          });
        });

        // Handle form submissions
        const forms = document.querySelectorAll("form");
        forms.forEach((form) => {
          // form.addEventListener("submit", function (e) {
             // e.preventDefault();
             // showToast("Settings saved successfully!");
           // });
        });
      });

      function confirmDeleteAccount() {
        if (
          confirm(
            "Are you sure you want to delete your account? This action cannot be undone."
          )
        ) {
          if (
            confirm(
              "This will permanently delete all your data, including kuppi sessions, resources, and community posts. Are you absolutely sure?"
            )
          ) {
            showToast("Account deletion request submitted.");
            // In real app, this would trigger account deletion process
          }
        }
      }

      function showToast(msg) {
        const toasts = document.querySelector(".c-toasts");
        if (!toasts) {
             const t = document.createElement('div');
             t.style.position = 'fixed';
             t.style.bottom = '20px';
             t.style.right = '20px';
             t.style.backgroundColor = '#333';
             t.style.color = 'white';
             t.style.padding = '12px 24px';
             t.style.borderRadius = '4px';
             t.style.zIndex = '9999';
             t.innerText = msg;
             document.body.appendChild(t);
             setTimeout(() => t.remove(), 4000);
             return;
        }
        const item = document.createElement("div");
        item.className = "c-toast";
      }
      
      const urlParams = new URLSearchParams(window.location.search);
      if (urlParams.has('success')) {
         showToast('Settings saved successfully!');
      }
      if (urlParams.has('error')) {
         showToast(urlParams.get('error'));
      }

      function previewImage(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('profileImagePreview').src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
      }
        item.textContent = msg;
        toasts.appendChild(item);
        setTimeout(() => {
          item.remove();
        }, 3000);
      }
    </script>
    
    <c:if test="${param.success eq 'true'}">
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                showToast("Settings saved successfully!");
            });
        </script>
    </c:if>
       
</layout:student-dashboard>
