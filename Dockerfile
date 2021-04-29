FROM perl:5.32
WORKDIR /opt
COPY cpanfile cpanfile
RUN cpanm --installdeps --notest .
COPY . .
EXPOSE 3000
CMD ["morbo", "script/course_management"]
