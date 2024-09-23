FROM python:3.9-alpine3.13
LABEL maintainer="kaayai.com"

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Copy the requirements files and app directory
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Set working directory
WORKDIR /app

# Expose port 8000 for the app
EXPOSE 8000

# ARG variable for development mode
ARG DEV=false

# Install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # Install development dependencies (including flake8) if DEV=true
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    # Cleanup temporary files
    rm -rf /tmp && \
    # Add a non-root user for running the app
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Ensure the virtual environment is in the PATH
ENV PATH="/py/bin:$PATH"

# Set the user to the non-root user
USER django-user
