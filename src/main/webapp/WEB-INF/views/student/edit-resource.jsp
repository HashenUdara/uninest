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
                       value="${resource.title}" placeholder="Enter resource title" class="c-field__input" />
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
                            <option value="${subj.subjectId}" ${subjectId == subj.subjectId ? 'selected' : ''}>${subj.code} - ${subj.name}</option>
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
                        <option value="${cat.categoryId}" ${resource.categoryId == cat.categoryId ? 'selected' : ''}>${cat.categoryName}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- File status message -->
            <c:if test="${resource.status == 'approved'}">
                <div class="c-alert c-alert--warning" role="alert">
                    <p><strong>Note:</strong> This resource is currently approved. Editing it will reset its status to "pending" and require re-approval by the subject coordinator.</p>
                </div>
            </c:if>

            <!-- Upload mode toggle -->
            <div class="c-tabs" role="tablist" aria-label="Select upload method">
                <button type="button" class="c-tabs__link" role="tab" 
                        data-mode="keep" id="tab-keep">Keep existing file</button>
                <button type="button" class="c-tabs__link" role="tab" 
                        data-mode="file" id="tab-file">Upload new file</button>
                <button type="button" class="c-tabs__link" role="tab" 
                        data-mode="link" id="tab-link">Use new link</button>
            </div>

            <!-- Mode: Keep existing -->
            <div id="mode-keep" class="js-upload-mode">
                <div class="c-field">
                    <label class="c-field__label">Current File</label>
                    <p class="c-field__hint u-text-muted">
                        <c:choose>
                            <c:when test="${resource.fileType == 'link'}">
                                Link: <a href="${resource.fileUrl}" target="_blank">${resource.fileUrl}</a>
                            </c:when>
                            <c:otherwise>
                                File: ${resource.fileUrl} (${resource.fileType})
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <!-- Mode: File -->
            <div id="mode-file" class="js-upload-mode" style="display: none;">
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

            <input type="hidden" id="upload-mode" name="uploadMode" value="keep" />
            <input type="hidden" id="keep-existing-file" name="keepExistingFile" value="true" />

            <!-- Actions -->
            <div class="c-form-actions">
                <a href="${pageContext.request.contextPath}/student/resources" 
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
                
                // Get preselected values
                const selectedSubjectId = ${subjectId != null ? subjectId : 'null'};
                const selectedTopicId = ${resource.topicId};
                
                // Tab switching for upload mode
                const tabs = document.querySelectorAll('.c-tabs__link[data-mode]');
                const modeKeep = document.getElementById('mode-keep');
                const modeFile = document.getElementById('mode-file');
                const modeLink = document.getElementById('mode-link');
                const uploadModeInput = document.getElementById('upload-mode');
                const keepExistingFileInput = document.getElementById('keep-existing-file');
                const fileInput = document.getElementById('file-input');
                const linkInput = document.getElementById('res-link');
                
                // Set initial mode based on resource type
                const isLink = '${resource.fileType}' === 'link';
                const initialMode = 'keep';
                
                tabs.forEach(tab => {
                    const mode = tab.getAttribute('data-mode');
                    if (mode === initialMode) {
                        tab.classList.add('is-active');
                    }
                    
                    tab.addEventListener('click', function() {
                        const clickedMode = this.getAttribute('data-mode');
                        tabs.forEach(t => t.classList.remove('is-active'));
                        this.classList.add('is-active');
                        
                        if (clickedMode === 'keep') {
                            modeKeep.style.display = 'block';
                            modeFile.style.display = 'none';
                            modeLink.style.display = 'none';
                            uploadModeInput.value = 'keep';
                            keepExistingFileInput.value = 'true';
                            fileInput.required = false;
                            linkInput.required = false;
                        } else if (clickedMode === 'file') {
                            modeKeep.style.display = 'none';
                            modeFile.style.display = 'block';
                            modeLink.style.display = 'none';
                            uploadModeInput.value = 'file';
                            keepExistingFileInput.value = 'false';
                            fileInput.required = true;
                            linkInput.required = false;
                        } else {
                            modeKeep.style.display = 'none';
                            modeFile.style.display = 'none';
                            modeLink.style.display = 'block';
                            uploadModeInput.value = 'link';
                            keepExistingFileInput.value = 'false';
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
                if (selectedSubjectId) {
                    subjectSelect.value = selectedSubjectId;
                    updateTopicSelect(selectedSubjectId, selectedTopicId);
                }
                
                // Initialize lucide icons
                if (window.lucide) {
                    lucide.createIcons();
                }
            });
        </script>
       
</layout:student-dashboard>
