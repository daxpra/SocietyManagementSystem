FROM tomcat:9.0-jdk17

# Remove default Tomcat application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy JSP/HTML/CSS/JS files
COPY WebContent /usr/local/tomcat/webapps/ROOT

# Compile Java Servlet classes
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

RUN javac \
    -cp "/usr/local/tomcat/lib/*" \
    -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    $(find src/main/java -name "*.java")

# Start Tomcat
EXPOSE 8080

CMD ["catalina.sh", "run"]
