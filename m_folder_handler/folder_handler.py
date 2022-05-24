import os

import shutil

from m_config.config import conf


class FolderHandler:
    @staticmethod
    def clear_create():
        temp_dir = conf.get_results_path()
        if os.path.isdir(temp_dir):
            shutil.rmtree(temp_dir)
        os.mkdir(temp_dir)

    @staticmethod
    def delete_result_folder():
        temp_dir = conf.get_results_path()
        if os.path.isdir(temp_dir):
            shutil.rmtree(temp_dir)

    @staticmethod
    def make_zip() -> None:
        shutil.make_archive(conf.get_zip_path(), "zip", conf.get_results_path())

    @staticmethod
    def copy_expenses(files_to_copy: list) -> None:
        res_dir_name = conf.get_results_path()
        for fts in files_to_copy:
            shutil.copy(fts["path"], res_dir_name + fts["name"])
