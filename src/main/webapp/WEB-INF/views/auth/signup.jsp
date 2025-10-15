<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="auth" tagdir="/WEB-INF/tags/auth" %>
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
    <h1 class="c-auth__title" id="auth-title">Create your account</h1>
    <c:if test="${not empty error}">
      <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
    </c:if>
    <form class="c-auth__form js-auth-form" method="post" action="${pageContext.request.contextPath}/signup" novalidate>
    <auth:field 
      id="fullName" 
      name="fullName" 
      label="Full Name" 
      type="text" 
      placeholder="Enter your full name" 
      required="true" 
      autocomplete="name"
      autofocus="true"
      value="${param.fullName}"
    />
    <auth:field 
      id="email" 
      name="email" 
      label="Email" 
      type="email" 
      placeholder="Enter your email" 
      required="true" 
      autocomplete="email"
      value="${param.email}"
    />
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
    
    <div class="c-password-meter" data-strength="0">
      <div class="c-password-meter__bar"></div>
      <p class="c-password-meter__label">Weak</p>
    </div>
    
    <auth:field 
      id="confirmPassword" 
      name="confirmPassword" 
      label="Confirm Password" 
      type="password" 
      placeholder="Confirm your password" 
      required="true" 
      autocomplete="new-password"
      minlength="6"
    />
    
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
    
    <auth:button text="Sign Up" />
  </form>
  
  <div class="c-auth__switch">
    Already have an account? <auth:link href="${pageContext.request.contextPath}/login" text="Login" />
  </div>
  
  <footer class="c-auth__legal">
    <auth:link href="#" text="Terms of Service" muted="true" />
    <span aria-hidden="true">·</span>
    <auth:link href="#" text="Privacy Policy" muted="true" />
  </footer>
  </jsp:body>
</layout:auth>
