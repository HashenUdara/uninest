<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Upload Resource" activePage="resources">
     
        <style>
            .c-form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: var(--space-4);
            }
        </style>
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/student/resources">My Resources</a>
            <span class="c-breadcrumbs__sep">/</span>
            <span aria-current="page">Upload Resource</span>
        </nav>
        <h1 class="c-page__title">Upload New Resource</h1>
    </header>

    <c:if test="${not empty error}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>${error}</p>
        </div>
    </c:if>

    <section class="c-panel">
        <form class="c-form" action="${pageContext.request.contextPath}/student/resources/upload" 
              method="post" enctype="multipart/form-data" id="uploadForm">
            
            <!-- Title -->
            <div class="c-field">
                <label for="res-title" class="c-field__label">Resource Title *</label>
                <input id="res-title" name="title" type="text" required 
                       placeholder="Enter resource title" class="c-field__input" />
            </div>

            <!-- Description -->
            <div class="c-field">
                <label for="res-desc" class="c-field__label">Description</label>
                <textarea id="res-desc" name="description" rows="4" class="c-field__input"
                          placeholder="Add a helpful description or key points"></textarea>
            </div>

            <!-- Grid row: subject/topic -->
            <div class="c-form-grid">
                <div class="c-field">
                    <label for="res-subject" class="c-field__label">Select Subject *</label>
                    <select id="res-subject" name="subjectId" class="c-select" required>
                        <option value="">Choose a subject</option>
                        <c:forEach items="${subjects}" var="subj">
                            <option value="${subj.subjectId}">${subj.code} - ${subj.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="c-field">
                    <label for="res-topic" class="c-field__label">Select Topic *</label>
                    <select id="res-topic" name="topicId" class="c-select" required>
                        <option value="">Choose a topic</option>
                    </select>
                </div>
            </div>

            <!-- Category -->
            <div class="c-field">
                <label for="res-category" class="c-field__label">Select Category *</label>
                <select id="res-category" name="categoryId" class="c-select" required>
                    <option value="">Select category</option>
                    <c:forEach items="${categories}" var="cat">
                        <option value="${cat.categoryId}">${cat.categoryName}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Upload mode toggle -->
            <div class="c-tabs" role="tablist" aria-label="Select upload method">
                <button type="button" class="c-tabs__link is-active" role="tab" 
                        data-mode="file" id="tab-file">Upload file</button>
                <button type="button" class="c-tabs__link" role="tab" 
                        data-mode="link" id="tab-link">Paste link</button>
            </div>

            <!-- Mode: File -->
            <div id="mode-file" class="js-upload-mode">
                <div class="c-field">
                    <label for="file-input" class="c-field__label">Choose File *</label>
                    <input type="file" id="file-input" name="file" class="c-field__input" 
                           accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.txt,.zip" />
                    <p class="c-field__hint u-text-muted">
                        Supported formats: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX, TXT, ZIP (Max 50MB)
                    </p>
                </div>
            </div>

            <!-- Mode: Link -->
            <div id="mode-link" class="js-upload-mode" style="display: none;">
                <div class="c-field">
                    <label for="res-link" class="c-field__label">Resource Link *</label>
                    <input id="res-link" name="link" type="url" 
                           placeholder="https://drive.google.com/..." class="c-field__input" />
                    <p class="c-field__hint u-text-muted">
                        Make sure the link is publicly accessible or shared with the right audience.
                    </p>
                </div>
            </div>

            <input type="hidden" id="upload-mode" name="uploadMode" value="file" />

            <!-- Actions -->
            <div class="c-form-actions">
                <a href="${pageContext.request.contextPath}/student/resources" 
                   class="c-btn c-btn--ghost">Cancel</a>
                <button type="submit" class="c-btn c-btn--primary">
                    <i data-lucide="upload"></i> Submit for Approval
                </button>
            </div>
        </form>
    </section>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Store all topics data
                const allTopics = [
                    <c:forEach items="${allTopics}" var="topic" varStatus="status">
                    {
                        topicId: ${topic.topicId},
                        subjectId: ${topic.subjectId},
                        name: "${topic.title}"
                    }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ];
                
                // Get preselected values
                const preselectedSubjectId = ${preselectedSubjectId != null ? preselectedSubjectId : 'null'};
                const preselectedTopicId = ${preselectedTopicId != null ? preselectedTopicId : 'null'};
                
                // Tab switching for upload mode
                const tabs = document.querySelectorAll('.c-tabs__link[data-mode]');
                const modeFile = document.getElementById('mode-file');
                const modeLink = document.getElementById('mode-link');
                const uploadModeInput = document.getElementById('upload-mode');
                const fileInput = document.getElementById('file-input');
                const linkInput = document.getElementById('res-link');
                
                tabs.forEach(tab => {
                    tab.addEventListener('click', function() {
                        const mode = this.getAttribute('data-mode');
                        tabs.forEach(t => t.classList.remove('is-active'));
                        this.classList.add('is-active');
                        
                        if (mode === 'file') {
                            modeFile.style.display = 'block';
                            modeLink.style.display = 'none';
                            uploadModeInput.value = 'file';
                            fileInput.required = true;
                            linkInput.required = false;
                        } else {
                            modeFile.style.display = 'none';
                            modeLink.style.display = 'block';
                            uploadModeInput.value = 'link';
                            fileInput.required = false;
                            linkInput.required = true;
                        }
                    });
                });
                
                // Filter topics when subject is selected
                const subjectSelect = document.getElementById('res-subject');
                const topicSelect = document.getElementById('res-topic');
                
                function updateTopicSelect(subjectId, selectTopicId) {
                    topicSelect.innerHTML = '<option value="">Choose a topic</option>';
                    
                    if (!subjectId) {
                        return;
                    }
                    
                    // Filter topics by selected subject
                    const filteredTopics = allTopics.filter(topic => topic.subjectId === subjectId);
                    
                    if (filteredTopics.length === 0) {
                        topicSelect.innerHTML = '<option value="">No topics available</option>';
                        return;
                    }
                    
                    filteredTopics.forEach(topic => {
                        const option = document.createElement('option');
                        option.value = topic.topicId;
                        option.textContent = topic.name;
                        if (selectTopicId && topic.topicId === selectTopicId) {
                            option.selected = true;
                        }
                        topicSelect.appendChild(option);
                    });
                }
                
                subjectSelect.addEventListener('change', function() {
                    const subjectId = parseInt(this.value);
                    updateTopicSelect(subjectId, null);
                });
                
                // Auto-select if preselected values are available
                if (preselectedSubjectId) {
                    subjectSelect.value = preselectedSubjectId;
                    updateTopicSelect(preselectedSubjectId, preselectedTopicId);
                }
                
                // Initialize lucide icons
                if (window.lucide) {
                    lucide.createIcons();
                }
            });
        </script>
       
</layout:student-dashboard>
