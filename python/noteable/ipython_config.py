from ipykernel_logging.main import configure_log_formatter

c.InteractiveShellApp.extensions = [
    "noteable",
]

c.SqlMagic.feedback = False
c.SqlMagic.autopandas = True
c.NTBLMagic.project_dir = "/var/run/noteable/project"
c.NoteableDataLoaderMagic.return_head = False
c.IPythonKernel._execute_sleep = 0.15
# 10 minutes to support large files
c.NTBLMagic.planar_ally_default_timeout_seconds = 600

c.Application.logging_config = {
    "version": 1,
    "formatters": {
        "structlog": {
            "()": configure_log_formatter,
        },
    },
    "handlers": {
        "default": {
            "class": "logging.StreamHandler",
            "formatter": "structlog",
            # if this is changed to stdout, we'll see logs in cell outputs
            "stream": "ext://sys.stderr",
        }
    },
    "loggers": {
        "IPKernelApp": {
            "handlers": ["default"],
            "level": "DEBUG",
        },
    },
}
