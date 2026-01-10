# Generate Reports

GitHub Action that generates Minecraft default reports.

[![Test Action](https://github.com/MinecraftPlayground/generate-reports/actions/workflows/test_action.yml/badge.svg)](https://github.com/MinecraftPlayground/generate-reports/actions/workflows/test_action.yml)

## Usage

```yaml
jobs:
  generate-reports:
    runs-on: ubuntu-latest
    steps:
      - name: 'Generate reports to "./default_reports"'
        id: generate_reports
        uses: MinecraftPlayground/generate-reports@main
        with:
          version: 1.21.2
          path: './default_reports'
```

### Inputs

| Key                     | Required? | Type                                   | Default                                                           | Description                                                                             |
| :---------------------- | --------- | -------------------------------------- | :---------------------------------------------------------------- | :-------------------------------------------------------------------------------------- |
| `version`               | No        | `string`                               | `latest-release`                                                  | Minecraft version to generate reports for or one of `latest-release`/`latest-snapshot`. |
| `path`                  | No        | `string`                               | `./default`                                                       | Relative path under `$GITHUB_WORKSPACE` to place the reports.                           |
| `manifest-url`          | No        | `string`                               | `https://piston-meta.mojang.com/mc/game/version_manifest_v2.json` | URL to the Minecraft manifest API.                                                      |
| `if-version-is-invalid` | No        | `warn` \| `error` \| `ignore` | `warn` | The desired behavior if the provided version is invalid.<br><br>Possible values:<ul><li>`warn`: Output a warning but do not fail the action</li><li>`error`: Fail the action with an error message</li><li>`ignore`: Do not output any warnings or errors, the action does not fail</li></ul> |

## License
The scripts and documentation in this project are released under the [GPLv3 License](./LICENSE).
