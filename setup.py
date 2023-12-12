from setuptools import setup


if __name__ == "__main__":
    setup(
        name="The Language",
        version="1.0.0",
        description="The Language Virtual Machine",
        url="https://github.com/FelixLuciano/the-language",
        author="Luciano Felix",
        packages=[
            "the_language",
            "the_language.nodes"
        ],
        package_dir={
            "the_language": "python",
            "the_language.nodes": "python/nodes",
        },
        license="MIT",
    )
