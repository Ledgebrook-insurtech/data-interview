from typing import Dict, List
from pathlib import Path
import pandas as pd

class ParseE02:
    def __init__(self):
        self.data_directory = Path(__file__).resolve().parent.parent / 'data'
        self.e02_file_path = self.data_directory / 'e029924d.012924'
        self.e02_schemas = self._load_schema()
        self.e02_file_content = self._load_e02_file()

    def _load_schema(self) -> Dict[str, pd.DataFrame]:
        e02_schema_path = self.data_directory / 'schemas'

        # Load the schema file
        print(f"Loading schema from {e02_schema_path}")

        return {
            file.stem: pd.read_csv(file)
            for file in e02_schema_path.glob('*.csv')
        }

    def _load_e02_file(self) -> List[str]:
        with open(self.e02_file_path, 'r', encoding='utf-8') as e02_file:
            return e02_file.readlines()
