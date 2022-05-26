import os

import shutil

from m_config.config import conf, DATA_RESULTS_PATH


class FolderHandler:
    @staticmethod
    def clear_create():
        if not os.path.isdir(DATA_RESULTS_PATH):
            os.mkdir(DATA_RESULTS_PATH)
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
            print(fts["path"])
            shutil.copy(fts["path"], res_dir_name + fts["name"])

    @staticmethod
    def copy_extra_files(files_to_copy:list) -> None:
        res_dir_name = conf.get_results_path()
        for i, fts in enumerate(files_to_copy):
            print(fts)
            print(res_dir_name + f"extra_file_{i}")
            shutil.copy(fts.split("//")[1], res_dir_name + fts.split("/")[-1])

