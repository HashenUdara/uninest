<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:student-dashboard pageTitle="${resource.title}" activePage="subjects">
    
    <style>
        /* Resource detail page scoped styles */
        .o-panel {
            background: var(--panel-bg);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-xl);
            padding: clamp(var(--space-6), 2vw, var(--space-8));
        }
        
        .c-media-viewer {
            margin-top: var(--space-4);
            aspect-ratio: 16/9;
            border-radius: var(--radius-lg);
            background: var(--color-surface);
            display: grid;
            place-items: center;
            color: var(--text-muted);
        }
        
        .c-media-viewer iframe,
        .c-media-viewer embed,
        .c-media-viewer object {
            width: 100%;
            height: 100%;
            border: 0;
            display: block;
            border-radius: inherit;
            background: var(--color-surface);
        }
        
        .c-actions {
            margin-top: var(--space-4);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: var(--space-3);
        }
        
        .c-kv-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(220px, 1fr));
            gap: var(--space-4) var(--space-8);
            padding: var(--space-4) 0;
            border-top: 1px solid var(--color-border);
            border-bottom: 1px solid var(--color-border);
            margin: var(--space-4) 0;
        }
        
        @media (max-width: 800px) {
            .c-kv-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .c-kv-grid__key {
            font-size: var(--fs-sm);
            color: var(--color-text-muted);
        }
        
        .c-kv-grid__val {
            font-weight: var(--fw-medium);
        }
        
        .c-rating {
            display: grid;
            grid-template-columns: 120px 1fr;
            gap: var(--space-4);
            align-items: start;
        }
        
        .c-rating__score {
            font-size: 2rem;
            font-weight: var(--fw-semibold);
        }
        
        .c-rating-bars {
            display: grid;
            gap: var(--space-2);
        }
        
        .c-rating-bars__row {
            display: grid;
            grid-template-columns: 18px 1fr 40px;
            gap: var(--space-2);
            align-items: center;
            font-size: var(--fs-sm);
            color: var(--color-text-muted);
        }
        
        .c-rating-bars__bar {
            position: relative;
            height: 8px;
            border-radius: var(--radius-pill);
            background: var(--color-border);
        }
        
        .c-rating-bars__bar::before {
            content: "";
            position: absolute;
            inset: 0;
            width: var(--pct, 0%);
            background: var(--color-brand);
            border-radius: inherit;
        }
        
        .c-comment {
            display: grid;
            grid-template-columns: 40px 1fr;
            gap: var(--space-3);
            padding: var(--space-3) 0;
            border-top: 1px solid var(--color-border);
        }
        
        .c-comment:first-of-type {
            border-top: 0;
        }
        
        .c-comment__avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--color-surface);
            border: 1px solid var(--color-border);
        }
        
        .c-comment__meta {
            font-size: var(--fs-xs);
            color: var(--color-text-muted);
            margin-bottom: var(--space-1);
        }
        
        .c-section {
            display: grid;
            gap: var(--space-5);
        }
    </style>
    
    <script>
        function getYouTubeEmbedUrl(url) {
            const regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/;
            const match = url.match(regExp);
            if (match && match[7].length === 11) {
                return 'https://www.youtube.com/embed/' + match[7];
            }
            return null;
        }
        
        function getGoogleDriveEmbedUrl(url) {
            // Handle Google Drive file URLs
            const fileIdMatch = url.match(/\/file\/d\/([^\/]+)/);
            if (fileIdMatch) {
                return 'https://drive.google.com/file/d/' + fileIdMatch[1] + '/preview';
            }
            // Handle Google Drive open URLs
            const openMatch = url.match(/[?&]id=([^&]+)/);
            if (openMatch) {
                return 'https://drive.google.com/file/d/' + openMatch[1] + '/preview';
            }
            return null;
        }
        
        function confirmDelete(resourceId) {
            if (confirm('Are you sure you want to delete this resource? This action cannot be undone.')) {
                document.getElementById('deleteResourceId').value = resourceId;
                document.getElementById('deleteForm').submit();
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            const viewer = document.querySelector('.c-media-viewer');
            const fileType = viewer?.getAttribute('data-filetype');
            const fileUrl = viewer?.getAttribute('data-fileurl');
            
            if (!viewer || !fileUrl) return;
            
            if (fileType === 'link') {
                // Handle external links
                if (fileUrl.includes('youtube.com') || fileUrl.includes('youtu.be')) {
                    const embedUrl = getYouTubeEmbedUrl(fileUrl);
                    if (embedUrl) {
                        viewer.innerHTML = '<iframe src="' + embedUrl + '" allowfullscreen></iframe>';
                    }
                } else if (fileUrl.includes('drive.google.com')) {
                    const embedUrl = getGoogleDriveEmbedUrl(fileUrl);
                    if (embedUrl) {
                        viewer.innerHTML = '<iframe src="' + embedUrl + '" allowfullscreen></iframe>';
                    }
                } else {
                    viewer.innerHTML = '<p>Preview not available for this link type. <a href="' + fileUrl + '" target="_blank">Open resource</a></p>';
                }
            } else if (fileType === 'pdf') {
                viewer.innerHTML = '<iframe src="${pageContext.request.contextPath}/' + fileUrl + '#view=FitH&toolbar=0"></iframe>';
            } else {
                viewer.innerHTML = '<p>Preview not available. <a href="${pageContext.request.contextPath}/' + fileUrl + '" download>Download resource</a></p>';
            }
            
            if (window.lucide) {
                lucide.createIcons();
            }
        });
    </script>

    <div class="o-panel">
        <header class="c-page__header">
            <nav class="c-breadcrumbs" aria-label="Breadcrumb">
                <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
                <span class="c-breadcrumbs__sep">/</span>
                <a href="${pageContext.request.contextPath}/student/subjects">My Subjects</a>
                <span class="c-breadcrumbs__sep">/</span>
                <a href="${pageContext.request.contextPath}/student/resources?topicId=${resource.topicId}">${resource.topicName}</a>
                <span class="c-breadcrumbs__sep">/</span>
                <span aria-current="page">${resource.title}</span>
            </nav>
            <div>
                <h1 class="c-page__title">${resource.title}</h1>
                <p class="c-page__subtitle u-text-muted" style="margin-top: var(--space-2)">
                    Uploaded by ${resource.uploaderName} · <fmt:formatDate value="${resource.uploadDate}" pattern="MMM dd, yyyy" />
                </p>
            </div>
            <div class="c-media-viewer" aria-label="Preview" 
                 data-filetype="${resource.fileType}" 
                 data-fileurl="${resource.fileUrl}">
                <p>Loading preview...</p>
            </div>
            <div class="c-actions">
                <div style="display: flex; gap: var(--space-2)">
                    <!-- Show edit and delete buttons if user owns the resource -->
                    <c:if test="${sessionScope.authUser.id == resource.uploadedBy}">
                        <a href="${pageContext.request.contextPath}/student/resources/edit?id=${resource.resourceId}" 
                           class="c-btn c-btn--sm c-btn--ghost">
                            <i data-lucide="edit"></i> Edit
                        </a>
                        <button type="button" onclick="confirmDelete(${resource.resourceId})" 
                                class="c-btn c-btn--sm c-btn--ghost c-btn--danger">
                            <i data-lucide="trash-2"></i> Delete
                        </button>
                    </c:if>
                </div>
                <div style="display: flex; gap: var(--space-2)">
                    <c:choose>
                        <c:when test="${resource.fileType == 'link'}">
                            <a href="${resource.fileUrl}" target="_blank" class="c-btn c-btn--sm">
                                <i data-lucide="external-link"></i> Open Resource
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/${resource.fileUrl}" download class="c-btn c-btn--sm">
                                <i data-lucide="download"></i> Download
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Delete confirmation form (hidden) -->
            <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/student/resources/delete" style="display: none;">
                <input type="hidden" name="id" id="deleteResourceId" />
            </form>
        </header>

        <section class="c-section">
            <div>
                <h2 class="c-section-title">Metadata</h2>
                <div class="c-kv-grid">
                    <div>
                        <div class="c-kv-grid__key">Subject</div>
                        <div class="c-kv-grid__val">${resource.subjectCode} - ${resource.subjectName}</div>
                    </div>
                    <div>
                        <div class="c-kv-grid__key">Topic</div>
                        <div class="c-kv-grid__val">${resource.topicName}</div>
                    </div>
                    <div>
                        <div class="c-kv-grid__key">Category</div>
                        <div class="c-kv-grid__val">${resource.categoryName}</div>
                    </div>
                    <div>
                        <div class="c-kv-grid__key">Type</div>
                        <div class="c-kv-grid__val">${resource.fileType == 'link' ? 'Online Resource' : resource.fileType.toUpperCase()}</div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty resource.description}">
                <div>
                    <h3 class="c-section-title">Description</h3>
                    <p class="u-text-muted">${resource.description}</p>
                </div>
            </c:if>

            <div>
                <h3 class="c-section-title">Ratings</h3>
                <div class="c-rating">
                    <div>
                        <div class="c-rating__score">4.5</div>
                        <div class="u-text-muted">12 reviews</div>
                    </div>
                    <div class="c-rating-bars">
                        <div class="c-rating-bars__row">
                            <span>5</span>
                            <div class="c-rating-bars__bar" style="--pct: 50%"></div>
                            <span>50%</span>
                        </div>
                        <div class="c-rating-bars__row">
                            <span>4</span>
                            <div class="c-rating-bars__bar" style="--pct: 30%"></div>
                            <span>30%</span>
                        </div>
                        <div class="c-rating-bars__row">
                            <span>3</span>
                            <div class="c-rating-bars__bar" style="--pct: 10%"></div>
                            <span>10%</span>
                        </div>
                        <div class="c-rating-bars__row">
                            <span>2</span>
                            <div class="c-rating-bars__bar" style="--pct: 5%"></div>
                            <span>5%</span>
                        </div>
                        <div class="c-rating-bars__row">
                            <span>1</span>
                            <div class="c-rating-bars__bar" style="--pct: 5%"></div>
                            <span>5%</span>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <h3 class="c-section-title">Comments</h3>
                <div class="c-comment">
                    <div class="c-comment__avatar" aria-hidden="true"></div>
                    <div>
                        <div class="c-comment__meta">Alex Johnson · Nov 1, 2023</div>
                        <div>These notes were incredibly helpful for my exam preparation. Thank you!</div>
                    </div>
                </div>
                <div class="c-comment">
                    <div class="c-comment__avatar" aria-hidden="true"></div>
                    <div>
                        <div class="c-comment__meta">Emily Clark · Oct 28, 2023</div>
                        <div>Clear and concise explanations. Highly recommend.</div>
                    </div>
                </div>
                <div class="c-comment">
                    <div class="c-comment__avatar" aria-hidden="true"></div>
                    <div>
                        <div class="c-comment__meta">David Lee · Oct 27, 2023</div>
                        <div>Great resource! Helped me understand the concepts better.</div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    
</layout:student-dashboard>
