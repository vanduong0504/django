import time

from psycopg2 import OperationalError as Psycopg2Error
from django.db.utils import OperationalError
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    """Django comand to wait for database"""

    def handle(self, *args, **options):
        self.stderr.write("Waiting for database...")
        db_up = False
        while db_up is False:
            try:
                self.check(databases=["postgresql"])
                db_up = True
            except (Psycopg2Error, OperationalError):
                self.stderr.write("Database not ready, waiting 1 second...")
        self.stderr.write(self.style.SUCCESS("Database ready"))
