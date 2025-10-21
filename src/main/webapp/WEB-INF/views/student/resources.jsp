<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="My Resources" activePage="resources">
   
        <script>
            // View toggle functionality
            document.addEventListener('DOMContentLoaded', function() {
                const toggleButtons = document.querySelectorAll('.js-view-toggle');
                const gridView = document.querySelector('.js-grid-view');
                const tableView = document.querySelector('.js-table-view');
                
                toggleButtons.forEach(btn => {
                    btn.addEventListener('click', function() {
                        const view = this.getAttribute('data-view');
                        toggleButtons.forEach(b => b.classList.remove('is-active'));
                        this.classList.add('is-active');
                        
                        if (view === 'grid') {
                            gridView.style.display = 'grid';
                            tableView.style.display = 'none';
                        } else {
                            gridView.style.display = 'none';
                            tableView.style.display = 'block';
                        }
                    });
                });
                
                // Initialize thumbnails for grid view
                initResourceThumbnails();
                
                // Initialize lucide icons
                if (window.lucide) {
                    lucide.createIcons();
                }
            });
            
            function initResourceThumbnails() {
                const cards = document.querySelectorAll('.c-card[data-filetype] .c-card__media.c-thumb');
                if (!cards.length) return;
                
                const iconMap = {
                    pdf: 'file-text',
                    doc: 'file-text',
                    docx: 'file-text',
                    txt: 'file-text',
                    ppt: 'file-input',
                    pptx: 'file-input',
                    xls: 'table',
                    xlsx: 'table',
                    image: 'image',
                    jpg: 'image',
                    jpeg: 'image',
                    png: 'image',
                    video: 'film',
                    mp4: 'film',
                    zip: 'file-archive',
                    link: 'link'
                };
                
                const palette = [
                    'hsl(210 100% 97%)',
                    'hsl(190 95% 95%)',
                    'hsl(150 60% 94%)',
                    'hsl(45 100% 95%)',
                    'hsl(270 80% 96%)',
                    'hsl(0 85% 96%)'
                ];
                
                cards.forEach((thumb, idx) => {
                    const article = thumb.closest('.c-card');
                    const type = (article?.getAttribute('data-filetype') || 'file').toLowerCase();
                    const icon = iconMap[type] || 'file';
                    const bg = palette[idx % palette.length];
                    
                    thumb.style.background = bg;
                    thumb.innerHTML = '<i data-lucide="' + icon + '"></i>';
                });
                
                if (window.lucide) {
                    lucide.createIcons();
                }
            }
        </script>
        
        <style>
            .c-resources-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: var(--space-4);
                margin-top: var(--space-4);
            }
            
            .c-thumb {
                display: grid;
                place-items: center;
                width: 100%;
                height: 200px;
                border-radius: var(--radius-3);
                background: var(--surface-2);
                color: var(--text-muted);
                position: relative;
                overflow: hidden;
            }
            
            .c-thumb svg {
                width: 60px;
                height: 60px;
                stroke-width: 1;
            }
        </style>
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <span aria-current="page">My Resources</span>
        </nav>
        <div class="c-page__titlebar">
            <div>
                <h1 class="c-page__title">My Resources</h1>
                <p class="c-page__subtitle u-text-muted">
                    Manage and track your uploaded study materials
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/student/resources/upload" class="c-btn c-btn--primary">
                <i data-lucide="upload"></i> Upload Resource
            </a>
        </div>
        
        <div class="c-tabs" role="tablist" aria-label="Resource categories">
            <a href="${pageContext.request.contextPath}/student/resources" 
               class="c-tabs__link ${empty selectedCategoryId ? 'is-active' : ''}" 
               role="tab">All Categories</a>
            <c:forEach items="${categories}" var="cat">
                <a href="${pageContext.request.contextPath}/student/resources?category=${cat.categoryId}" 
                   class="c-tabs__link ${selectedCategoryId == cat.categoryId ? 'is-active' : ''}" 
                   role="tab">${cat.categoryName}</a>
            </c:forEach>
        </div>
    </header>

    <c:if test="${param.upload == 'success'}">
        <div class="c-alert c-alert--success" role="alert">
            <p>Resource uploaded successfully! It will be visible after coordinator approval.</p>
        </div>
    </c:if>

    <section>
        <div class="c-table-toolbar">
            <div class="c-table-toolbar__left">
                <span class="u-text-muted">
                    ${resources.size()} resource(s)
                </span>
            </div>
            <div class="c-table-toolbar__right">
                <button class="c-btn c-btn--sm c-btn--ghost js-view-toggle" data-view="grid" aria-label="Switch to grid view">
                    <i data-lucide="grid-3x3"></i> Grid
                </button>
                <button class="c-btn c-btn--sm c-btn--ghost js-view-toggle is-active" data-view="table" aria-label="Switch to table view">
                    <i data-lucide="list"></i> Table
                </button>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty resources}">
                <div class="c-empty-state">
                    <div class="c-empty-state__icon" aria-hidden="true">
                        <i data-lucide="folder-open"></i>
                    </div>
                    <h3 class="c-empty-state__title">No resources yet</h3>
                    <p class="c-empty-state__message">
                        Start uploading study materials to share with your peers.
                    </p>
                    <a href="${pageContext.request.contextPath}/student/resources/upload" class="c-btn c-btn--primary">
                        <i data-lucide="upload"></i> Upload Your First Resource
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Grid View -->
                <div class="c-resources-grid js-grid-view" style="display: none;">
                    <c:forEach items="${resources}" var="res">
                        <article class="c-card" data-filetype="${res.fileType}">
                            <div class="c-card__media c-thumb" data-file-type="${res.fileType}"></div>
                            <div class="c-card__body">
                                <h3 class="c-card__title">${res.title}</h3>
                                <p class="c-card__meta">${res.subjectName} - ${res.topicName}</p>
                                <p class="c-card__meta">${res.categoryName}</p>
                                <div class="c-badge c-badge--${res.status == 'approved' ? 'success' : res.status == 'rejected' ? 'danger' : 'warning'}">
                                    ${res.status}
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>

                <!-- Table View -->
                <div class="c-table-wrap js-table-view">
                    <table class="c-table c-table--sticky" aria-label="My resources">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Subject</th>
                                <th>Topic</th>
                                <th>Category</th>
                                <th>Upload Date</th>
                                <th>Status</th>
                                <th class="u-text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${resources}" var="res">
                                <tr>
                                    <td>
                                        <div class="c-comm-cell">
                                            <span class="c-comm-cell__avatar" aria-hidden="true" data-file-type="${res.fileType}">
                                                <i data-lucide="file-text"></i>
                                            </span>
                                            <div class="c-comm-cell__meta">
                                                <span class="c-comm-cell__title">${res.title}</span>
                                                <c:if test="${not empty res.description}">
                                                    <span class="c-comm-cell__sub u-text-muted">${res.description}</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${res.subjectCode}</td>
                                    <td>${res.topicName}</td>
                                    <td>${res.categoryName}</td>
                                    <td><fmt:formatDate value="${res.uploadDate}" pattern="MMM dd, yyyy" /></td>
                                    <td>
                                        <span class="c-badge c-badge--${res.status == 'approved' ? 'success' : res.status == 'rejected' ? 'danger' : 'warning'}">
                                            ${res.status}
                                        </span>
                                    </td>
                                    <td class="u-text-right">
                                        <div class="c-table-actions">
                                            <c:if test="${res.status == 'approved'}">
                                                <a href="${pageContext.request.contextPath}/${res.fileUrl}" 
                                                   class="c-btn c-btn--sm c-btn--ghost" 
                                                   target="_blank" 
                                                   aria-label="Download">
                                                    <i data-lucide="download"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
    
</layout:student-dashboard>
