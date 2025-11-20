# Contributing

Community driven development of this package is encouraged. To maintain code quality standards, please adhere to the following guidlines when contributing:
 - To get started, <a href="https://www.clahub.com/agreements/NREL/PowerSystems.jl">sign the Contributor License Agreement</a>.
 - Please do your best to adhere to our [coding style guide](https://nrel-sienna.github.io/InfrastructureSystems.jl/latest/style).
 - To submit code contributions, [fork](https://help.github.com/articles/fork-a-repo/) the repository, commit your changes, and [submit a pull request](https://help.github.com/articles/creating-a-pull-request-from-a-fork/).

## Testing with Custom Package Branches

When working on a pull request, you can test your changes with a specific branch of a dependency package by commenting on the PR with the following syntax:

```
PackageName#branch-name
```

For example, to test with the `main` branch of `InfrastructureSystems`:

```
InfrastructureSystems#main
```

This will trigger a custom test workflow that runs the full test suite with the specified package and branch. The workflow will:
- React to your comment with a 🚀 emoji to indicate it has started
- Run tests on Ubuntu, Windows, and macOS
- Post the results as a comment on the PR

This feature is useful when you're developing coordinated changes across multiple packages in the NREL-Sienna ecosystem.
