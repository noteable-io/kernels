c.InteractiveShellApp.extensions = [
    "sql",
    "noteable_magics",
]

c.SqlMagic.feedback = False
c.SqlMagic.autopandas = True
c.NTBLMagic.project_dir = "/etc/noteable/project"
c.NoteableDataLoaderMagic.return_head = False
c.IPythonKernel._execute_sleep=0.15
# 10 minutes to support large files
c.NTBLMagic.planar_ally_default_timeout_seconds = 600
