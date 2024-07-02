from pathlib import Path
import pandas as pd

class ParseE02:
    def __init__(self):
        self.e02_schemas = {}
        self.data_directory = Path(__file__).resolve().parent.parent / 'data'
        self.e02_file_path = self.data_directory / 'e029924d.012924'
        self.e02_file_content = []

    def load_schema(self):
        """ Load e02 Schema from Excel File """
        e02_schema_path = self.data_directory / 'schema'

        # Load the schema file
        print(f"Loading schema from {e02_schema_path}")

        self.e02_schemas = {
            file.stem: pd.read_csv(file)
            for file in e02_schema_path.glob('*.csv')
        }

    def load_e02_file(self):
        """ Load E02 file content """
        with open(self.e02_file_path, 'r') as e02_file:
            self.e02_file_content = e02_file.readlines()

