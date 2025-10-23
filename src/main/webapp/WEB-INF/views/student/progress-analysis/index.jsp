<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Progress Analysis" activePage="progress">
    <jsp:body> 
         <link rel="stylesheet" href="${pageContext.request.contextPath}/static/app.css" />

        <style>
          /* Minimal, scoped styles for Performance Analytics page */

/* Stats grid */
.o-grid--stats {
  display: grid;
  gap: var(--space-4);
  grid-template-columns: repeat(3, minmax(180px, 1fr));
  margin-bottom: var(--space-6);
}
.o-grid {
  margin-top: var(--space-6);
}
@media (max-width: 900px) {
  .o-grid--stats {
    grid-template-columns: 1fr;
  }
}

/* Stat card */
.c-stat {
  background: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-5);
}
.c-stat__label {
  font-size: var(--fs-sm);
}
.c-stat__value {
  font-size: 1.75rem;
  font-weight: var(--fw-semibold);
}

/* Panel header (title + button) */
.c-panel__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-4);
  margin-bottom: var(--space-4);
}

/* KPI row above chart */
.c-kpi {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--space-4);
  margin-bottom: var(--space-4);
}
.c-kpi__value {
  font-size: 2rem;
  font-weight: var(--fw-semibold);
}
.c-kpi__label {
  font-size: var(--fs-sm);
}
.c-kpi__delta {
  font-size: var(--fs-sm);
  color: var(--color-success);
}

/* Chart box */
.c-chart {
  height: 280px;
}

/* Compact chart variant */
.c-chart--sm {
  height: 220px;
}

/* Two-up panel grid */
.o-grid--panels {
  display: grid;
  gap: var(--space-4);
  grid-template-columns: repeat(2, minmax(260px, 1fr));
}
@media (max-width: 1000px) {
  .o-grid--panels {
    grid-template-columns: 1fr;
  }
}

/* Legend bullets for donut */
.c-legend {
  list-style: none;
  padding: 0;
  margin: var(--space-3) 0 0;
  display: grid;
  gap: var(--space-2);
  grid-template-columns: repeat(2, minmax(160px, 1fr));
  color: var(--color-text-muted);
  font-size: var(--fs-sm);
}
.c-legend .c-bullet {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
  margin-right: 8px;
  background: var(--bullet, var(--color-brand));
}

/* Simple list for milestones */
.c-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: var(--space-3);
}
.c-list__item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-3);
}
.c-list__title {
  font-weight: var(--fw-medium);
}

/* Subject progress list */
.c-progress-list {
  display: grid;
  gap: var(--space-3);
}
.c-progress-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: var(--fs-sm);
}
.c-meter {
  position: relative;
  height: 10px;
  border-radius: var(--radius-pill);
  background: var(--color-border);
  overflow: hidden;
}
.c-meter__bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: var(--pct, 0%);
  background: var(--color-brand);
}

        </style>

    
   
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/student/progress-analysis">Progress Analysis</a>
            
        </nav>
    </header>

    <c:if test="${not empty error}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>${error}</p>
        </div>
    </c:if>

 <div class="comm-layout">
            <div class="c-page">
            <header class="c-page__header">
             
                <div>
            <h1 class="c-page__title">Performance Analytics</h1>
            <p class="c-page__subtitle u-text-muted">
              Track your academic progress and identify areas for improvement.
            </p>
          </div>
            </header>

               <!-- KPIs -->
        <section class="o-grid o-grid--stats">
          <div class="c-stat">
            <div class="c-stat__label u-text-muted">Enrolled Subjects</div>
            <div class="c-stat__value">5</div>
          </div>
          <div class="c-stat">
            <div class="c-stat__label u-text-muted">Completed Topics</div>
            <div class="c-stat__value">32</div>
          </div>
          <div class="c-stat">
            <div class="c-stat__label u-text-muted">Current GPA</div>
            <div class="c-stat__value">3.7</div>
          </div>
        </section>

        <!-- GPA Progression -->
        <section class="c-panel">
          <div class="c-panel__header">
            <h2 class="c-section-title" style="margin: 0">GPA Progression</h2>
            <a href="gpa-calculator.html" class="c-btn c-btn--secondary"
              >Open GPA Calculator</a
            >
          </div>
          <div class="c-kpi">
            <div>
              <div class="c-kpi__value">3.75</div>
              <div class="c-kpi__label u-text-muted">GPA Trend</div>
            </div>
            <div class="c-kpi__delta u-text-success">
              Semesters <span>+0.2%</span>
            </div>
          </div>
          <div class="c-chart">
            <canvas
              id="gpaChart"
              aria-label="GPA Trend over semesters"
              role="img"
            ></canvas>
          </div>
        </section>

        <!-- Time by Subject + Milestones -->
        <section class="o-grid o-grid--panels">
          <div class="c-panel">
            <div class="c-panel__header">
              <h2 class="c-section-title" style="margin: 0">
                Time Spent by Subject
              </h2>
            </div>
            <div class="c-chart c-chart--sm">
              <canvas
                id="timeBySubjectChart"
                aria-label="Hours by subject"
                role="img"
              ></canvas>
            </div>
          </div>

          <div class="c-panel">
            <div class="c-panel__header">
              <h2 class="c-section-title" style="margin: 0">
                Subject Progress
              </h2>
            </div>
            <!-- Subject Progress -->

            <div class="c-progress-list">
              <div class="c-progress-row">
                <span>Calculus II</span><span>75%</span>
              </div>
              <div class="c-meter" style="--pct: 75%">
                <span class="c-meter__bar"></span>
              </div>

              <div class="c-progress-row">
                <span>Organic Chemistry</span><span>60%</span>
              </div>
              <div class="c-meter" style="--pct: 60%">
                <span class="c-meter__bar"></span>
              </div>

              <div class="c-progress-row">
                <span>Data Structures</span><span>85%</span>
              </div>
              <div class="c-meter" style="--pct: 85%">
                <span class="c-meter__bar"></span>
              </div>

              <div class="c-progress-row">
                <span>Linear Algebra</span><span>50%</span>
              </div>
              <div class="c-meter" style="--pct: 50%">
                <span class="c-meter__bar"></span>
              </div>

              <div class="c-progress-row">
                <span>Probability and Statistics</span><span>90%</span>
              </div>
              <div class="c-meter" style="--pct: 90%">
                <span class="c-meter__bar"></span>
              </div>
            </div>
          </div>
        </section>
        <!-- Activity + Distribution -->
        <section class="o-grid o-grid--panels">
          <div class="c-panel">
            <div class="c-panel__header">
              <h2 class="c-section-title" style="margin: 0">Study Activity</h2>
            </div>
            <div class="c-chart c-chart--sm">
              <canvas
                id="studyActivityChart"
                aria-label="Study hours per week"
                role="img"
              ></canvas>
            </div>
          </div>

          <div class="c-panel">
            <div class="c-panel__header">
              <h2 class="c-section-title" style="margin: 0">
                Grade Distribution
              </h2>
            </div>
            <div class="c-chart c-chart--sm">
              <canvas
                id="gradeDonutChart"
                aria-label="Grade distribution"
                role="img"
              ></canvas>
            </div>
            <ul class="c-legend" aria-label="Grade legend">
              <li>
                <span
                  class="c-bullet"
                  style="--bullet: var(--color-brand)"
                ></span
                >A (40%)
              </li>
              <li>
                <span
                  class="c-bullet"
                  style="--bullet: rgba(84, 44, 245, 0.65)"
                ></span
                >B (30%)
              </li>
              <li>
                <span
                  class="c-bullet"
                  style="--bullet: rgba(84, 44, 245, 0.45)"
                ></span
                >C (20%)
              </li>
              <li>
                <span
                  class="c-bullet"
                  style="--bullet: rgba(84, 44, 245, 0.25)"
                ></span
                >D/F (10%)
              </li>
            </ul>
          </div>
        </section>
          </div>

        </div>
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<script>
      // Initialize icons via global app.js
      document.addEventListener("DOMContentLoaded", function () {
        if (window.lucide) window.lucide.createIcons();
      });

      // Chart.js setup: minimal, brand-colored with soft area fill
      // Wait for DOM to be ready to ensure CSS is loaded
      document.addEventListener("DOMContentLoaded", function () {
        // Hardcode brand color to avoid CSS variable issues
        const brand = '#542cf5';
        const text = "#101623";
        const textMuted = "#667085";
        const grid = "#d9dce2";
        
        console.log('Using brand color:', brand);

        function hexToRgb(hex) {
          // Remove # if present
          hex = hex.replace(/^#/, '');
          
          // Handle 3-digit hex
          if (hex.length === 3) {
            hex = hex.split('').map(char => char + char).join('');
          }
          
          const m = hex.match(/^([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i);
          if (!m) {
            console.warn('Invalid hex color:', hex, '- using default');
            return { r: 84, g: 44, b: 245 };
          }
          return {
            r: parseInt(m[1], 16),
            g: parseInt(m[2], 16),
            b: parseInt(m[3], 16),
          };
        }

        const ctxEl = document.getElementById("gpaChart");
        if (!ctxEl || !window.Chart) return;
        
        // Pre-calculate RGB for reuse
        const rgb = hexToRgb(brand);
        console.log('Brand color:', brand, 'RGB:', rgb);

        const chart = new Chart(ctxEl, {
          type: "line",
          data: {
            labels: [
              "Fall '21",
              "Spring '22",
              "Fall '22",
              "Spring '23",
              "Fall '23",
            ],
            datasets: [
              {
                data: [3.4, 3.6, 3.1, 3.8, 3.95],
                borderColor: brand,
                borderWidth: 2.5,
                pointRadius: 0,
                pointHoverRadius: 3,
                pointHitRadius: 8,
                tension: 0.35,
                fill: "start",
                backgroundColor: (c) => {
                  const { ctx, chartArea } = c.chart;
                  if (!chartArea) return "transparent";
                  const g = ctx.createLinearGradient(
                    0,
                    chartArea.top,
                    0,
                    chartArea.bottom
                  );
                  // Use pre-calculated RGB values
                  g.addColorStop(0, `rgba(84, 44, 245, 0.16)`);
                  g.addColorStop(1, `rgba(84, 44, 245, 0.00)`);
                  return g;
                },
              },
            ],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: { display: false },
              tooltip: {
                padding: 10,
                displayColors: false,
                callbacks: {
                  label: (ctx) => `GPA: ${ctx.parsed.y}`,
                },
              },
            },
            elements: {
              line: { borderJoinStyle: "round", capBezierPoints: true },
              point: { radius: 0 },
            },
            layout: { padding: { top: 8, right: 8, left: 8, bottom: 0 } },
            scales: {
              y: {
                suggestedMin: 0,
                suggestedMax: 4,
                border: { display: false },
                grid: {
                  color: (ctx) =>
                    ctx.tick.value % 1 === 0 ? grid : "transparent",
                },
                ticks: {
                  color: textMuted,
                  maxTicksLimit: 3,
                  callback: (v) => v,
                },
              },
              x: {
                border: { display: false },
                grid: { display: false },
                ticks: { color: textMuted, maxRotation: 0 },
              },
            },
          },
        });

        // Recompute gradient on resize
        window.addEventListener("resize", () => chart.update("none"));

        // Study Activity: minimal line with soft fill
        const actEl = document.getElementById("studyActivityChart");
        if (actEl) {
          const activity = new Chart(actEl, {
            type: "line",
            data: {
              labels: [
                "Week 1",
                "Week 2",
                "Week 3",
                "Week 4",
                "Week 5",
                "Week 6",
              ],
              datasets: [
                {
                  data: [8, 12, 10, 13, 14, 18],
                  borderColor: brand,
                  borderWidth: 2.5,
                  pointRadius: 0,
                  tension: 0.35,
                  fill: "start",
                  backgroundColor: (c) => {
                    const { ctx, chartArea } = c.chart;
                    if (!chartArea) return "transparent";
                    const g = ctx.createLinearGradient(
                      0,
                      chartArea.top,
                      0,
                      chartArea.bottom
                    );
                    g.addColorStop(0, `rgba(84, 44, 245, 0.14)`);
                    g.addColorStop(1, `rgba(84, 44, 245, 0.00)`);
                    return g;
                  },
                },
              ],
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              plugins: {
                legend: { display: false },
                tooltip: { displayColors: false },
              },
              scales: {
                y: {
                  border: { display: false },
                  grid: {
                    color: (c) =>
                      c.tick.value % 5 === 0 ? grid : "transparent",
                  },
                  ticks: { color: textMuted, maxTicksLimit: 4 },
                },
                x: {
                  border: { display: false },
                  grid: { display: false },
                  ticks: { color: textMuted },
                },
              },
            },
          });
          window.addEventListener("resize", () => activity.update("none"));
        }

        // Grade Distribution: donut
        const donutEl = document.getElementById("gradeDonutChart");
        if (donutEl) {
          const donut = new Chart(donutEl, {
            type: "doughnut",
            data: {
              labels: ["A", "B", "C", "D/F"],
              datasets: [
                {
                  data: [40, 30, 20, 10],
                  backgroundColor: [
                    `rgba(84, 44, 245, 1)`,
                    `rgba(84, 44, 245, .65)`,
                    `rgba(84, 44, 245, .45)`,
                    `rgba(84, 44, 245, .25)`,
                  ],
                  borderWidth: 0,
                  hoverOffset: 3,
                },
              ],
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              cutout: "65%",
              plugins: { legend: { display: false } },
            },
          });
        }

        // Time spent by subject: horizontal bars
        const timeEl = document.getElementById("timeBySubjectChart");
        if (timeEl) {
          new Chart(timeEl, {
            type: "bar",
            data: {
              labels: [
                "Calculus II",
                "Organic Chem",
                "Data Structures",
                "Linear Algebra",
                "Probability",
              ],
              datasets: [
                {
                  data: [12, 9, 15, 7, 10],
                  backgroundColor: `rgba(84, 44, 245, .75)`,
                  borderRadius: 6,
                  barThickness: 18,
                },
              ],
            },
            options: {
              indexAxis: "y",
              responsive: true,
              maintainAspectRatio: false,
              plugins: { legend: { display: false } },
              scales: {
                x: {
                  border: { display: false },
                  grid: {
                    color: (c) =>
                      c.tick.value % 5 === 0 ? grid : "transparent",
                  },
                  ticks: { color: textMuted },
                },
                y: {
                  border: { display: false },
                  grid: { display: false },
                  ticks: { color: textMuted },
                },
              },
            },
          });
        }
      });
    </script>
       

    </jsp:body>
    
    </layout:student-dashboard>
