# 1. Use a stable Python version (using slim for smaller image size)
FROM python:3.14.3-slim

# 2. Set environment variables to keep Python from buffering logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Set initial working directory
WORKDIR /app

# 4. Install dependencies
# We copy this first to take advantage of Docker's layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of your code

COPY . .

# 6. Move into the actual Django project folder (where manage.py lives)
WORKDIR /app/django-site

# 7. Collect static files for WhiteNoise to serve
RUN python manage.py collectstatic --noinput

# 8. Start the server
# We use the shell form (no brackets) so the $PORT variable from GCP works
# Migrations run at container startup so they have access to the live database
CMD python manage.py migrate && gunicorn --bind 0.0.0.0:$PORT campus_resource.wsgi:application
