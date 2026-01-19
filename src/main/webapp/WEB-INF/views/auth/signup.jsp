<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Sign Up">
  <jsp:attribute name="scripts">
    <script>
      // Form validation
      document.querySelector(".js-auth-form").classList.add("js-validate");
      
      // Password strength meter
      const passwordInput = document.getElementById("password");
      const meter = document.querySelector(".c-password-meter");
      const meterLabel = meter.querySelector(".c-password-meter__label");
      
      const strengthLabels = ["Weak", "Weak", "Fair", "Good", "Strong"];
      
      function calculateStrength(password) {
        let strength = 0;
        if (password.length >= 6) strength++;
        if (password.length >= 10) strength++;
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
        if (/\d/.test(password)) strength++;
        if (/[^a-zA-Z0-9]/.test(password)) strength++;
        return Math.min(strength, 4);
      }
      
      passwordInput.addEventListener("input", function() {
        const strength = calculateStrength(this.value);
        meter.setAttribute("data-strength", strength);
        meterLabel.textContent = strengthLabels[strength];
      });
      
      // Confirm password validation
      const confirmInput = document.getElementById("confirmPassword");
      confirmInput.addEventListener("input", function() {
        const errorEl = document.querySelector('[data-error-for="confirmPassword"]');
        if (this.value && this.value !== passwordInput.value) {
          errorEl.textContent = "Passwords do not match";
          this.closest(".c-field").classList.add("is-invalid");
        } else {
          errorEl.textContent = "";
          this.closest(".c-field").classList.remove("is-invalid");
        }
      });
    </script>
  </jsp:attribute>
  <jsp:body>
  <style>
  .c-auth{
    max-width: 600px;
    margin: 0 auto;
  }
/* Form is now a 2-column grid */
.c-auth__form {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-6);
  column-gap: var(--space-4);
}

/* Password meter spans both columns */
.c-password-meter {
  grid-column: 1 / -1;
}

/* Role section spans both columns, with subgrid for options */
.c-role-select {
  grid-column: 1 / -1;
}

/* Submit button spans both columns */
.c-auth__submit {
  grid-column: 1 / -1;
}
  </style>
    <h1 class="c-auth__title" id="auth-title">Create your account</h1>
    <c:if test="${not empty error}">
      <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
    </c:if>
    <form class="c-auth__form js-auth-form"  method="post" action="${pageContext.request.contextPath}/signup" novalidate>
    <div style="display: flex; gap: 1rem; grid-column: 1 / -1;">
      <div class="c-field" style="flex: 1;">
        <label for="firstName" class="c-field__label">First Name</label>
        <input
          type="text"
          id="firstName"
          name="firstName"
          class="c-field__input"
          placeholder="e.g. Amal"
          autocomplete="given-name"
          value="${param.firstName}"
          autofocus
        />
        <p class="c-field__error" data-error-for="firstName" aria-live="polite"></p>
      </div>
      
      <div class="c-field" style="flex: 1;">
        <label for="lastName" class="c-field__label">Last Name</label>
        <input
          type="text"
          id="lastName"
          name="lastName"
          class="c-field__input"
          placeholder="e.g. Perera"
          autocomplete="family-name"
          value="${param.lastName}"
        />
        <p class="c-field__error" data-error-for="lastName" aria-live="polite"></p>
      </div>
    </div>
    
    <div class="c-field" style="grid-column: 1 / -1;">
      <label for="email" class="c-field__label">Email</label>
      <input
        type="email"
        id="email"
        name="email"
        class="c-field__input"
        placeholder="Enter your email"
        required
        autocomplete="email"
        value="${param.email}"
      />
      <p class="c-field__error" data-error-for="email" aria-live="polite"></p>
    </div>
    <div class="c-field">
      <label for="password" class="c-field__label">Password</label>
      <input
        type="password"
        id="password"
        name="password"
        class="c-field__input"
        placeholder="Create a password"
        required
        autocomplete="new-password"
        minlength="6"
      />
      <p class="c-field__error" data-error-for="password" aria-live="polite"></p>
    </div>
    
    <div class="c-field">
      <label for="confirmPassword" class="c-field__label">Confirm Password</label>
      <input
        type="password"
        id="confirmPassword"
        name="confirmPassword"
        class="c-field__input"
        placeholder="Confirm your password"
        required
        autocomplete="new-password"
        minlength="6"
      />
      <p class="c-field__error" data-error-for="confirmPassword" aria-live="polite"></p>
    </div>
    
    <div class="c-password-meter" data-strength="0">
      <div class="c-password-meter__bar"></div>
      <p class="c-password-meter__label">Weak</p>
    </div>
    
    <div class="c-field">
      <label for="academicYear" class="c-field__label">Academic year</label>
      <select id="academicYear" name="academicYear" class="c-field__input">
        <option value="">Select...</option>
        <option value="1" ${param.academicYear == '1' ? 'selected' : ''}>1st Year</option>
        <option value="2" ${param.academicYear == '2' ? 'selected' : ''}>2nd Year</option>
        <option value="3" ${param.academicYear == '3' ? 'selected' : ''}>3rd Year</option>
        <option value="4" ${param.academicYear == '4' ? 'selected' : ''}>4th Year</option>
      </select>
      <p class="c-field__error" data-error-for="academicYear" aria-live="polite"></p>
    </div>

    <div class="c-field">
      <label for="university" class="c-field__label">University (Sri Lanka)</label>
      <select id="university" style="width: 100%;" name="universityId" class="c-field__input">
        <option value="">Select...</option>
        <c:forEach items="${universities}" var="uni">
          <option value="${uni.id}" ${param.universityId == uni.id ? 'selected' : ''}>${uni.name}</option>
        </c:forEach>
      </select>
      <p class="c-field__error" data-error-for="university" aria-live="polite"></p>
    </div>

    <div class="c-field">
      <label for="universityIdNumber" class="c-field__label">University ID</label>
      <input
        type="text"
        id="universityIdNumber"
        name="universityIdNumber"
        class="c-field__input"
        placeholder="Eg: 2023/CS/025"
        autocomplete="off"
        value="${param.universityIdNumber}"
      />
      <p class="c-field__error" data-error-for="universityIdNumber" aria-live="polite"></p>
    </div>

    <div class="c-field">
      <label for="faculty" class="c-field__label">Faculty</label>
      <input
        type="text"
        id="faculty"
        name="faculty"
        class="c-field__input"
        placeholder="Eg: Faculty of Arts"
        autocomplete="off"
        value="${param.faculty}"
      />
      <p class="c-field__error" data-error-for="faculty" aria-live="polite"></p>
    </div>

    <div class="c-role-select">
      <label class="c-role-select__label">Select Your Role</label>
      <div class="c-role-select__options">
        <div class="c-role-option">
          <input 
            type="radio" 
            id="role-student" 
            name="role" 
            value="student" 
            class="c-role-option__input"
            ${empty param.role || param.role == 'student' ? 'checked' : ''}
            required
          />
          <label for="role-student" class="c-role-option__label">
            <span class="c-role-option__icon" aria-hidden="true">
              <i data-lucide="graduation-cap"></i>
            </span>
            <span class="c-role-option__name">Student</span>
            <span class="c-role-option__desc">Access courses and materials</span>
          </label>
        </div>
        <div class="c-role-option">
          <input 
            type="radio" 
            id="role-moderator" 
            name="role" 
            value="moderator" 
            class="c-role-option__input"
            ${param.role == 'moderator' ? 'checked' : ''}
          />
          <label for="role-moderator" class="c-role-option__label">
            <span class="c-role-option__icon" aria-hidden="true">
              <i data-lucide="shield-check"></i>
            </span>
            <span class="c-role-option__name">Moderator</span>
            <span class="c-role-option__desc">Manage content and users</span>
          </label>
        </div>
      </div>
    </div>
    
    <button type="submit" class="c-btn c-btn--primary c-auth__submit">Sign Up</button>
  </form>
  
  <div class="c-auth__switch">
    Already have an account? <a href="${pageContext.request.contextPath}/login" class="c-link">Login</a>
  </div>
  
  <footer class="c-auth__legal">
    <a href="#" class="c-link c-link--muted">Terms of Service</a>
    <span aria-hidden="true">·</span>
    <a href="#" class="c-link c-link--muted">Privacy Policy</a>
  </footer>
  </jsp:body>
</layout:auth>
