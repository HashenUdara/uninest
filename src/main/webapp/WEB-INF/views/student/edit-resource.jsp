<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Edit Resource" activePage="resources">
     
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
            <span aria-current="page">Edit Resource</span>
        </nav>
        <h1 class="c-page__title">Edit Resource</h1>
        <c:if test="${resource.status eq 'approved'}">
            <div class="c-alert c-alert--info" role="alert" style="margin-top: 1rem;">
                <p><strong>Note:</strong> This resource is currently approved. Your edits will be sent for approval. The current version will remain visible until the new version is approved.</p>
            </div>
        </c:if>
    </header>

    <c:if test="${not empty error}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>${error}</p>
        </div>
    </c:if>

    <section class="c-panel">
        <form class="c-form" action="${pageContext.request.contextPath}/student/resources/edit" 
              method="post" enctype="multipart/form-data" id="editForm">
            
            <input type="hidden" name="resourceId" value="${resource.resourceId}" />
            
            <!-- Title -->
            <div class="c-field">
                <label for="res-title" class="c-field__label">Resource Title *</label>
                <input id="res-title" name="title" type="text" required 
                       value="${resource.title}"
                       placeholder="Enter resource title" class="c-field__input" />
            </div>

            <!-- Description -->
            <div class="c-field">
                <label for="res-desc" class="c-field__label">Description</label>
                <textarea id="res-desc" name="description" rows="4" class="c-field__input"
                          placeholder="Add a helpful description or key points">${resource.description}</textarea>
            </div>

            <!-- Grid row: subject/topic -->
            <div class="c-form-grid">
                <div class="c-field">
                    <label for="res-subject" class="c-field__label">Select Subject *</label>
                    <select id="res-subject" name="subjectId" class="c-select" required>
                        <option value="">Choose a subject</option>
                        <c:forEach items="${subjects}" var="subj">
                            <option value="${subj.subjectId}" ${subj.subjectId == resource.topicId ? 'selected' : ''}>${subj.code} - ${subj.name}</option>
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
                        <option value="${cat.categoryId}" ${cat.categoryId == resource.categoryId ? 'selected' : ''}>${cat.categoryName}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Upload mode toggle -->
            <div class="c-tabs" role="tablist" aria-label="Select upload method">
                <button type="button" class="c-tabs__link ${resource.fileType != 'link' ? 'is-active' : ''}" role="tab" 
                        data-mode="file" id="tab-file">Upload file</button>
                <button type="button" class="c-tabs__link ${resource.fileType == 'link' ? 'is-active' : ''}" role="tab" 
                        data-mode="link" id="tab-link">Paste link</button>
            </div>

            <!-- Mode: File -->
            <div id="mode-file" class="js-upload-mode" ${resource.fileType == 'link' ? 'style="display: none;"' : ''}>
                <div class="c-field">
                    <label for="file-input" class="c-field__label">Choose New File (optional)</label>
                    <input type="file" id="file-input" name="file" class="c-field__input" 
                           accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.txt,.zip" />
                    <p class="c-field__hint u-text-muted">
                        Leave empty to keep the current file. Upload a new file to replace it.
                    </p>
                    <c:if test="${resource.fileType != 'link'}">
                        <p class="c-field__hint">Current file: ${resource.fileUrl}</p>
                    </c:if>
                </div>
            </div>

            <!-- Mode: Link -->
            <div id="mode-link" class="js-upload-mode" ${resource.fileType != 'link' ? 'style="display: none;"' : ''}>
                <div class="c-field">
                    <label for="res-link" class="c-field__label">Resource Link *</label>
                    <input id="res-link" name="link" type="url" 
                           value="${resource.fileType == 'link' ? resource.fileUrl : ''}"
                           placeholder="https://drive.google.com/..." class="c-field__input" />
                    <p class="c-field__hint u-text-muted">
                        Make sure the link is publicly accessible or shared with the right audience.
                    </p>
                </div>
            </div>

            <input type="hidden" id="upload-mode" name="uploadMode" value="${resource.fileType == 'link' ? 'link' : 'file'}" />

            <!-- Actions -->
            <div class="c-form-actions">
                <a href="${pageContext.request.contextPath}/student/resources/${resource.resourceId}" 
                   class="c-btn c-btn--ghost">Cancel</a>
                <button type="submit" class="c-btn c-btn--primary">
                    <i data-lucide="save"></i> Save Changes
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
                
                // Current topic ID
                const currentTopicId = ${resource.topicId};
                
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
                            fileInput.required = false; // Not required for edit
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
                
                // Find the subject for the current topic and set it
                const currentTopic = allTopics.find(t => t.topicId === currentTopicId);
                if (currentTopic) {
                    subjectSelect.value = currentTopic.subjectId;
                    updateTopicSelect(currentTopic.subjectId, currentTopicId);
                }
                
                // Initialize lucide icons
                if (window.lucide) {
                    lucide.createIcons();
                }
            });
        </script>
       
</layout:student-dashboard>
