# File Upload Storage Configuration

## Overview

The application now stores uploaded files in a permanent location outside the Tomcat webapps directory to prevent data loss during redeployments.

## Storage Location

### Uploaded Files Directory

```
/Users/hashen/uninest-uploads/resources/
```

This directory will be **automatically created** when the first file is uploaded.

### Benefits of This Approach:

✅ Files survive application redeployments  
✅ Files are not deleted when you run `./redeploy.sh`  
✅ Easier to backup (single location)  
✅ Can be shared across multiple Tomcat instances if needed

## How It Works

### 1. **File Upload** (`UploadResourceServlet.java`)

- When a user uploads a file, it's saved to: `/Users/hashen/uninest-uploads/resources/`
- Files are renamed with timestamps to avoid conflicts: `1234567890_originalname.pdf`
- The relative path is stored in the database: `resources/1234567890_originalname.pdf`

### 2. **File Access** (`FileServlet.java`)

- A new servlet serves files from the external directory
- URL pattern: `/uninest/uploads/resources/1234567890_originalname.pdf`
- Includes security checks to prevent directory traversal attacks

### 3. **Database Storage**

- Only the relative path is stored in the database: `resources/filename.ext`
- This makes the system portable and allows for easy migration

## File Structure

```
/Users/hashen/
└── uninest-uploads/           # Base upload directory
    └── resources/             # Resource files
        ├── 1729512345678_lecture-notes.pdf
        ├── 1729512456789_assignment.docx
        └── 1729512567890_slides.pptx
```

## Security Features

1. **Path Validation**: Prevents directory traversal attacks
2. **File Type Validation**: Only allowed file types can be uploaded
3. **Size Limits**: Maximum 50MB per file
4. **Authentication**: Only authenticated users can upload

## Manual Folder Creation (Optional)

If you want to create the folder manually before the first upload:

```bash
mkdir -p ~/uninest-uploads/resources
```

But this is **NOT required** - the folder will be created automatically!

## Accessing Uploaded Files

### In JSP/HTML:

```jsp
<a href="${pageContext.request.contextPath}/uploads/${resource.fileUrl}">
    Download File
</a>
```

### Direct URL:

```
http://localhost:8080/uninest/uploads/resources/1234567890_document.pdf
```

## Backup Recommendation

To backup all uploaded files:

```bash
tar -czf uninest-uploads-backup-$(date +%Y%m%d).tar.gz ~/uninest-uploads
```

## Changing the Upload Location

To change the upload location, edit the `UPLOAD_BASE_PATH` constant in:

- `UploadResourceServlet.java` (line 36)
- `FileServlet.java` (line 16)

Example for a different location:

```java
private static final String UPLOAD_BASE_PATH = "/var/uninest-data/uploads";
```
