FROM perl:5.32
WORKDIR /opt
COPY cpanfile cpanfile
RUN cpanm --installdeps --notest .

# COPY . .
COPY script script
COPY course-management.yml course-management.yml
COPY courses courses
COPY public public
COPY templates templates
COPY lib lib

# COPY lib script ./


EXPOSE 3000
CMD ["morbo", "script/course_management"]
