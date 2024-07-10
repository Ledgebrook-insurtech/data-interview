# Use an official Python runtime as a parent image
FROM python:3.11-slim-bookworm AS base

ARG INTERVIEW_TYPE

# Upgrade pip
RUN pip3 install --upgrade pip

# Setup non-root user
RUN useradd --create-home penguin
WORKDIR /home/data-interview

# Venv creation + activation
ENV VIRTUAL_ENV=/home/data-interview/venv
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
ENV INTERVIEW_TYPE=${INTERVIEW_TYPE}


# Copy only the necessary files to install dependencies
COPY interview_tests/${INTERVIEW_TYPE}/pyproject.toml poetry.lock* ./interview_tests/${INTERVIEW_TYPE}/

WORKDIR /home/data-interview/interview_tests/${INTERVIEW_TYPE}

# Install Poetry using pip in the virtual environment
RUN pip3 install --no-cache-dir poetry

# Install project dependencies with Poetry
RUN poetry install --no-dev

# Install pytest using pip in the virtual environment
RUN pip3 install pytest

# Copy src directory
COPY interview_tests/${INTERVIEW_TYPE}/src ./src

# Copy src directory
COPY interview_tests/${INTERVIEW_TYPE}/data ./data

# Switch to non-root user
USER penguin

# Command to run the application
CMD ["python", "src"]
