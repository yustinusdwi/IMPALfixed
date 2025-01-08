# Menggunakan image resmi Tomcat
FROM tomcat:9-jdk8

# Menyalin file .war ke folder webapps Tomcat
COPY dist/example-java-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/

# Mengekspos port 8080 untuk akses aplikasi
EXPOSE 8080

# Perintah untuk menjalankan Tomcat
CMD ["catalina.sh", "run"]
