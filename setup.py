import logging
import os
import shutil
from datetime import datetime
from typing import Dict, Any, List

import click
from jinja2 import Environment, FileSystemLoader, UndefinedError
from InquirerPy import prompt

VERSION = '0.1.0'

class TemplateRenderer:
    """
    TemplateRenderer is responsible for rendering Jinja2 templates with the provided context.
    """
    def __init__(self, templates_to_render, target_dir, context) -> None:
        self.templates_to_render = templates_to_render
        self.target_dir = target_dir
        self.context = context

    def render_all(self):
        """
        Render all templates in the templates_to_render dictionary.
        Each template is rendered with the context provided and saved to the target directory.

        :return: None
        """
        for template_path, output_path in self.templates_to_render.items():
            output_path = os.path.join(self.target_dir, output_path)
            self.render_template(template_path, str(output_path))

    def render_template(self, template_path: str, output_path: str) -> None:
        """
        Render a template file with the given context and save it to the output path.

        :param template_path: The path to the template file.
        :param output_path: The path where the rendered file will be saved.
        :return: None
        """
        try:
            env = Environment(
                loader=FileSystemLoader(os.path.dirname(template_path)),
                block_start_string='[[%',
                block_end_string='%]]',
                variable_start_string='[[',
                variable_end_string=']]',
            )
            template = env.get_template(os.path.basename(template_path))
            content = template.render(self.context)
            os.makedirs(os.path.dirname(output_path), exist_ok=True)
            with open(output_path, 'w') as file:
                file.write(content)
        except UndefinedError as err:
            logging.error(f"Error rendering template {template_path}: {err}")
            raise

class DirectoryManager:
    """
    DirectoryManager is responsible for managing the target directory and creating necessary directories.
    """
    def __init__(self, target_dir: str, package_name: str) -> None:
        self.target_dir = target_dir
        self.package_name = package_name

    def delete_target_directory(self):
        """
        Delete the target directory if it exists, except for the current directory.

        :return: None
        """
        if os.path.exists(self.target_dir) and self.target_dir != '.':
            shutil.rmtree(self.target_dir)

    def create_directories(self):
        """
        Create the necessary directories for the project structure.

        :return: None
        """
        os.makedirs(self.target_dir, exist_ok=True)
        os.makedirs(os.path.join(self.target_dir, '.github', 'workflows'), exist_ok=True)
        os.makedirs(os.path.join(self.target_dir, 'tests'), exist_ok=True)
        os.makedirs(os.path.join(self.target_dir, "src", self.package_name), exist_ok=True)
        os.makedirs(os.path.join(self.target_dir, "src", self.package_name, 'controllers'), exist_ok=True)
        os.makedirs(os.path.join(self.target_dir, "src", self.package_name, 'models'), exist_ok=True)
        os.makedirs(os.path.join(self.target_dir, "src", self.package_name, 'schemas'), exist_ok=True)
        os.makedirs(os.path.join(self.target_dir, "src", self.package_name, 'views'), exist_ok=True)

    def create_package_init_file(self):
        """
        Create an empty __init__.py file in the package directory to make it a package.

        :return: None
        """
        package_dir = os.path.join(self.target_dir, "src", self.package_name)
        os.makedirs(package_dir, exist_ok=True)
        init_file_path = os.path.join(str(package_dir), '__init__.py')
        with open(init_file_path, 'w') as init_file:
            pass

class ProjectSetup:
    """
    ProjectSetup orchestrates the setup process for generating project files.
    """
    def __init__(self, target_dir: str, context: Dict[str, Any], templates_to_render: Dict[str, str]) -> None:
        self.target_dir = target_dir
        self.context = context
        self.templates_to_render = templates_to_render
        self.package_name = context['package_name']
        self.dir_manager = DirectoryManager(target_dir, self.package_name)
        self.renderer = TemplateRenderer(templates_to_render, target_dir, context)

    def run(self):
        """
        Execute the project setup process.
        """
        self.dir_manager.delete_target_directory()
        self.dir_manager.create_directories()
        self.renderer.render_all()
        self.dir_manager.create_package_init_file()
        print(f"Setup complete! Files generated in: {os.path.abspath(self.target_dir)}")

def get_templates_config(package_name: str) -> Dict[str, Any]:
    """
    Get the templates configuration for the project setup.
    This function returns a dictionary mapping template paths to their corresponding output paths.

    :param package_name: The name of the package to be used in the project.
    :return: A dictionary mapping template paths to their corresponding output paths.
    """
    return {
        'templates/.github/workflows/python-checks.yml.jinja2': os.path.join('.github', 'workflows', 'python-checks.yml'),
        'templates/.github/workflows/release.yml.jinja2': os.path.join('.github', 'workflows', 'release.yml'),
        'templates/.github/workflows/test.yml.jinja2': os.path.join('.github', 'workflows', 'test.yml'),
        'templates/tests/__init__.py.jinja2': 'tests/__init__.py',
        'templates/tests/conftest.py.jinja2': 'tests/conftest.py',
        'templates/tests/test_example.py.jinja2': 'tests/test_example.py',
        'templates/.flake8.jinja2': '.flake8',
        'templates/.gitignore.jinja2': '.gitignore',
        'templates/.isort.cfg.jinja2': '.isort.cfg',
        'templates/.pylintrc.jinja2': '.pylintrc',
        'templates/commitlint.config.js.jinja2': 'commitlint.config.js',
        'templates/eslint.config.cjs.jinja2': 'eslint.config.cjs',
        'templates/LICENSE.jinja2': 'LICENSE',
        'templates/mypy.ini.jinja2': 'mypy.ini',
        'templates/package.json.jinja2': 'package.json',
        'templates/pyproject.toml.jinja2': 'pyproject.toml',
        'templates/pytest.ini.jinja2': 'pytest.ini',
        'templates/README.md.jinja2': 'README.md',
        'templates/tasks.py.jinja2': 'tasks.py',
        'templates/release.config.js.jinja2': 'release.config.js',
        'templates/update_version.py.jinja2': 'update_version.py',
        'templates/src/app/__init__.py.jinja2': os.path.join("src", package_name, '__init__.py'),
        'templates/src/app/logger.py.jinja2': os.path.join("src", package_name, 'logger.py'),
        'templates/src/app/conf.py.jinja2': os.path.join("src", package_name, 'conf.py'),
        'templates/src/app/main.py.jinja2': os.path.join("src", package_name, 'main.py'),
        'templates/src/app/utils.py.jinja2': os.path.join("src", package_name, 'utils.py'),
        'templates/src/app/controllers/__init__.py.jinja2': os.path.join("src", package_name, 'controllers', '__init__.py'),
        'templates/src/app/models/__init__.py.jinja2': os.path.join("src", package_name, 'models', '__init__.py'),
        'templates/src/app/schemas/__init__.py.jinja2': os.path.join("src", package_name, 'schemas', '__init__.py'),
        'templates/src/app/views/__init__.py.jinja2': os.path.join("src", package_name, 'views', '__init__.py'),
    }

def get_questions() -> List[Dict[str, str]]:
    return [
        {"type": "input", "name": "project_name", "message": "Enter the project name:", "default": "My Project"},
        {"type": "input", "name": "project_owner", "message": "Enter the GitHub project owner name:", "default": "fflintstone"},
        {"type": "input", "name": "author", "message": "Enter the author name:", "default": "Fred Flintstone"},
        {"type": "input", "name": "description", "message": "Enter the project description:", "default": "A sample project"},
        {"type": "input", "name": "license", "message": "Enter the license type (e.g., MIT):", "default": "MIT"},
        {"type": "input", "name": "email", "message": "Enter the author email:", "default": "fred.flintstone@example.com"},
    ]

def prepare_context() -> Dict[str, Any]:
    """
    Prepare the context for rendering templates.
    This function prompts the user for project details and returns a dictionary

    :return: A dictionary containing project details and other context information.
    """
    questions = get_questions()
    context = prompt(questions)
    context['version'] = VERSION
    context['year'] = str(datetime.now().year)
    context['module_name'] = context['project_name'].lower().replace(" ", "-")
    context['package_name'] = context['project_name'].lower().replace(" ", "_")

    return context

@click.command()
@click.option('--target-dir', '-t', default='.', help='Target directory for generated files (default: current directory).')
def main(target_dir: str):
    """Setup script to generate project files based on templates."""
    context = prepare_context()
    templates_to_render = get_templates_config(context['package_name'])
    setup = ProjectSetup(target_dir, context, templates_to_render)
    setup.run()

if __name__ == "__main__":
    main()
