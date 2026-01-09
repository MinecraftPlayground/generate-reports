# Generate Reports

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
          path: './default_data'
```

### Inputs

| Key            | Required? | Type     | Default                                                           | Description                                                                            |
| :------------- | --------- | -------- | :---------------------------------------------------------------- | :------------------------------------------------------------------------------------- |
| `version`      | No        | `string` | `latest-release`                                                  | Minecraft version to generate assets for or one of `latest-release`/`latest-snapshot`. |
| `path`         | No        | `string` | `./default`                                                       | Relative path under `$GITHUB_WORKSPACE` to place the assets.                           |
| `manifest-url` | No        | `string` | `https://piston-meta.mojang.com/mc/game/version_manifest_v2.json` | URL to the Minecraft manifest API.                                                     |

## License
The scripts and documentation in this project are released under the [GPLv3 License](./LICENSE).
