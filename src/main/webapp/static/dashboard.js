/*
  Global JS Utilities for UniNest
  - Theme toggle (persisted)
  - Form validation helper
  - Password strength meter (hook-based)

  Architecture principles:
  * No framework assumptions
  * Progressive enhancement; safe to load at end of body
  * Small, pure helpers exported to window.UniNest for future extension
*/
(function () {
  const ns = (window.UniNest = window.UniNest || {});

  /* ================= Theme ================= */
  const THEME_KEY = "uninest-theme";
  // Two-state theme only (light/dark)

  function applyTheme(theme) {
    const root = document.documentElement;
    if (theme === "dark") root.setAttribute("data-theme", "dark");
    else if (theme === "light") root.setAttribute("data-theme", "light");
    else root.setAttribute("data-theme", "light");
    updateThemeToggle();
  }
  function storedTheme() {
    return localStorage.getItem(THEME_KEY);
  }
  function setStoredTheme(val) {
    localStorage.setItem(THEME_KEY, val);
  }
  function cycleTheme() {
    const current =
      document.documentElement.getAttribute("data-theme") || "light";
    const next = current === "dark" ? "light" : "dark";
    setStoredTheme(next);
    applyTheme(next);
  }
  function updateThemeToggle() {
    const btn = document.querySelector(".js-theme-toggle");
    if (!btn) return;
    const theme =
      document.documentElement.getAttribute("data-theme") || "light";
    const labelEl = btn.querySelector(".c-theme-toggle__label");
    const iconEl = btn.querySelector(".c-theme-toggle__icon");
    let iconName = "",
      text = "";
    if (theme === "dark") {
      iconName = "moon";
      text = "Dark";
      btn.setAttribute("aria-pressed", "true");
    } else {
      iconName = "sun";
      text = "Light";
      btn.setAttribute("aria-pressed", "false");
    }
    if (iconEl && window.lucide) {
      iconEl.innerHTML = `<i data-lucide="${iconName}"></i>`;
      window.lucide.createIcons();
    }
    if (labelEl) labelEl.textContent = text;
  }
  function initTheme() {
    const btn = document.querySelector(".js-theme-toggle");
    if (btn) {
      btn.addEventListener("click", cycleTheme);
      const stored = storedTheme();
      if (stored) applyTheme(stored);
      else applyTheme("light");
    }
  }

  ns.theme = { applyTheme, cycleTheme };

  /* ================= Form Validation ================= */
  function validateForm(form) {
    let valid = true;
    form.querySelectorAll(".c-field").forEach((fieldEl) => {
      const input = fieldEl.querySelector("input,textarea,select");
      const errorEl = fieldEl.querySelector(".c-field__error");
      if (input && !input.checkValidity()) {
        valid = false;
        if (errorEl) errorEl.textContent = input.validationMessage;
        fieldEl.classList.add("is-invalid");
      } else if (errorEl) {
        errorEl.textContent = "";
        fieldEl.classList.remove("is-invalid");
      }
    });
    return valid;
  }
  function attachValidation(form) {
    form.addEventListener("submit", (e) => {
      if (!validateForm(form)) e.preventDefault();
    });
  }
  ns.forms = { validateForm, attachValidation };

  /* ================= Password Strength ================= */
  function passwordScore(pw) {
    let score = 0;
    if (pw.length >= 8) score++;
    if (/[A-Z]/.test(pw)) score++;
    if (/[0-9]/.test(pw)) score++;
    if (/[^A-Za-z0-9]/.test(pw)) score++;
    return score;
  }
  function initPasswordMeter(inputSelector, meterSelector) {
    const input = document.querySelector(inputSelector);
    const meter = document.querySelector(meterSelector);
    if (!input || !meter) return;
    const label = meter.querySelector(".js-password-strength-label");
    input.addEventListener("input", () => {
      const val = input.value.trim();
      const score = passwordScore(val);
      const pct = (score / 4) * 100 + "%";
      meter.style.setProperty("--meter-pct", pct);
      meter.setAttribute("data-strength", String(score));
      const words = ["Very weak", "Weak", "Fair", "Good", "Strong"];
      if (label) label.textContent = words[score];
    });
  }
  ns.password = { passwordScore, initPasswordMeter };

  /* ================= Organization Switcher ================= */
  const ORG_KEY = "uninest-active-org";
  function getActiveOrg() {
    return localStorage.getItem(ORG_KEY) || "Default University";
  }
  function setActiveOrg(org) {
    localStorage.setItem(ORG_KEY, org);
  }
  function initOrgSwitcher() {
    document.querySelectorAll(".js-org-select").forEach((sel) => {
      const current = getActiveOrg();
      // If the current value exists in options, select it; otherwise keep first
      Array.from(sel.options).forEach((opt) => {
        if (opt.value === current) sel.value = current;
      });
      sel.addEventListener("change", () => {
        setActiveOrg(sel.value);
        // Optional: emit a custom event for components to react
        document.dispatchEvent(
          new CustomEvent("uninest:org-changed", { detail: { org: sel.value } })
        );
      });
    });
    // Reflect active org into any placeholder nodes
    const orgNodes = document.querySelectorAll(".js-active-org");
    orgNodes.forEach((n) => (n.textContent = getActiveOrg()));
  }
  ns.org = { initOrgSwitcher, getActiveOrg, setActiveOrg };

  /* ================= Init (DOM Ready) ================= */
  document.addEventListener("DOMContentLoaded", () => {
    // Initialize Lucide icons
    if (window.lucide) {
      window.lucide.createIcons();
    }
    initTheme();
    initOrgSwitcher();
    document
      .querySelectorAll("form.js-validate")
      .forEach((f) => attachValidation(f));
  });
})();

/* ===== Organization Management Functions ===== */

// Initialize organization avatars and counts
function initOrgAvatars() {
  function avatarColorFromChar(ch) {
    const A = "A".charCodeAt(0);
    const idx = Math.max(0, (ch.toUpperCase().charCodeAt(0) - A) % 26);
    const hue = Math.round((360 / 26) * idx);
    const bg = `hsl(${hue} 85% 92%)`;
    const fg = `hsl(${hue} 60% 35%)`;
    return { bg, fg };
  }

  function firstAlpha(name) {
    if (!name) return "U";
    const normalized = name.normalize("NFD").replace(/\p{Diacritic}+/gu, "");
    const match = normalized.match(/[A-Za-z]/);
    return match ? match[0].toUpperCase() : "U";
  }

  document.querySelectorAll("table.c-table[data-org-table]").forEach((table) => {
    const countEl = table.closest("section")?.querySelector(".js-org-count");
    const rows = table.querySelectorAll("tbody tr");
    if (countEl) countEl.textContent = String(rows.length);
    
    table.querySelectorAll(".c-org-cell").forEach((row) => {
      const titleEl = row.querySelector(".c-org-cell__title");
      const avatarEl = row.querySelector(".c-org-cell__avatar");
      if (!titleEl || !avatarEl) return;
      const title = titleEl.textContent.trim();
      const first = firstAlpha(title);
      const { bg, fg } = avatarColorFromChar(first);
      avatarEl.style.setProperty("--avatar-bg", bg);
      avatarEl.style.setProperty("--avatar-fg", fg);
      avatarEl.textContent = first;
    });
  });
}

// Initialize organization confirm modals
function initOrgConfirm() {
  const modal = document.getElementById("confirm-modal");
  if (!modal) return;

  let pendingAction = null;
  let pendingForm = null;

  document.addEventListener("click", (e) => {
    const approve = e.target.closest && e.target.closest(".js-org-approve");
    const reject = e.target.closest && e.target.closest(".js-org-reject");
    const del = e.target.closest && e.target.closest(".js-org-delete");
    const trigger = approve || reject || del;
    
    if (!trigger) return;
    
    e.preventDefault();
    
    const titleText = approve
      ? "Approve organization"
      : reject
      ? "Reject organization"
      : "Delete organization";
    
    const bodyText = approve
      ? "Are you sure you want to approve this organization?"
      : reject
      ? "Are you sure you want to reject this organization?"
      : "Are you sure you want to delete this organization? This action cannot be undone.";
    
    const title = modal.querySelector("#confirm-title");
    const body = modal.querySelector(".c-modal__body p");
    if (title) title.textContent = titleText;
    if (body) body.textContent = bodyText;
    
    pendingForm = trigger.closest("form");
    
    modal.hidden = false;
    modal.querySelector(".js-confirm-action")?.focus();
  });

  modal.addEventListener("click", (e) => {
    if (e.target.matches("[data-close]")) {
      modal.hidden = true;
      pendingForm = null;
    }
  });

  const confirmBtn = modal.querySelector(".js-confirm-action");
  if (confirmBtn) {
    confirmBtn.addEventListener("click", () => {
      if (pendingForm) {
        pendingForm.submit();
      }
      modal.hidden = true;
      pendingForm = null;
    });
  }

  document.addEventListener("keydown", (e) => {
    if (!modal.hidden && e.key === "Escape") {
      modal.hidden = true;
      pendingForm = null;
    }
  });
}

// Initialize on DOM ready
document.addEventListener("DOMContentLoaded", function() {
  initOrgAvatars();
  initOrgConfirm();
});
