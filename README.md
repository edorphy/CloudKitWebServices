# CloudKit Web Services

This package enables developers to write code that interacts with CloudKit in targets that don't support the CloudKit Framework directly (such as App Clips).

## Stability

This project is currently undergoing development and is subject to breaking changes. During this development Semantic Versioning will not be followed entirely as long as the package remains under release version 1.0.0.

## Contributing

The goal of this project is to provide developers with easy access to CloudKit where it is not available such as within App Clips. If you find something missing that you'd like to see get added, open up an issue, or if you're comfortable writing framework code, open up a Pull Request.

## Requirements

- An Apple Developer account with access to the [CloudKit Console](https://icloud.developer.apple.com/)
- iOS 15.0 or newer

## Getting Started

To get started with CloudKit Web Services, first create a `CKWSContainer`.

```

// Configuration
let identifier = "iCloud.{your-container-name}"
let token = "{your-token-generated-from-cloudkit-console}"

let container = CKWSContainer(identifier: identifier, token: token, enviornment: .development)

```

Creating a query request

```

// Create an operation that queries all records of the "ExampleType"
let queryOperation = CKWSQueryOperation(query: CKWSQuery(recordType: "ExampleType"))

queryOperation.recordMatchedBlock = { recordID, result in 
  switch result {
  case .success(let record):
    // TODO: Do something with the record that was received.
    break
    
  case .failure(let error):
    // TODO: Handle per-record failure, perhaps retry fetching it manually in case an asset failed to download or something like that.
    break
}

queryOperation.queryResultBlock = { result in 
  switch result {
  case .success:
    // TODO: Yay, the operation was successful, now do something. Perhaps reload your awesome UI.
    break
    
  case .failure(let error):
    // TODO: An error happened at the operation level, check the error and decide what to do. Retry might be applicable, or tell the user to connect to internet, etc..
    break
}

container.publicCloudDatabase.add(queryOperation)

```
