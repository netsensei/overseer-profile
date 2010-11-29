core = "6.x"
api = "2"

; Drupal

projects[] = drupal

; Contrib projects
projects[admin_menu][subdir] = "contrib"
projects[admin_menu][version] = "1"

projects[ckeditor][subdir] = "contrib"
projects[ckeditor][version] = "1"

projects[pathauto][subdir] = "contrib"
projects[pathauto][version] = "1"

projects[token][subdir] = "contrib"
projects[token][version] = "1"

projects[views][subdir] = "contrib"
projects[views][version] = "2"

projects[comment_upload][subdir] = "contrib"
projects[comment_upload][version] = "1"

projects[project][subdir] = "contrib"
projects[project][version] = "1"

projects[project_issue][subdir] = "contrib"
projects[project_issue][version] = "1"

libraries[ckeditor][download][type] = "get"
libraries[ckeditor][download][url] = "http://download.cksource.com/CKEditor/CKEditor/CKEditor%203.2.1/ckeditor_3.2.1.tar.gz"
libraries[ckeditor][destination] = "libraries"