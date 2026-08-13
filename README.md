# Flutter SOAP Practice — Patient History App

A Flutter practice app that talks to a **SOAP 1.1** (document/literal) patient-history service. You search patients, open a profile, view medical history, add a condition, and manage medications.

The contract lives in [`WSDL.xml`](WSDL.xml). There is no real backend in this repo — mock the four operations on [Beeceptor](https://beeceptor.com) from that WSDL, then point the app at the mock URL.

**Stack:** `http`, `xml`, `provider`

**Layout:** feature-based (`lib/core`, `lib/features`, `lib/main.dart`) with two layers per feature:

- **data** — repository, models, SOAP resources
- **ui** — screens, widgets, controllers

---

## What is a SOAP API?

SOAP (Simple Object Access Protocol) is an XML protocol. Every call is an HTTP `POST` of an XML document wrapped in a standard envelope:

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <!-- operation request or response goes here -->
  </soap:Body>
</soap:Envelope>
```

The service contract is a **WSDL** (Web Services Description Language) file. It defines:

- **types** — XML Schema for records (Patient, Condition, …)
- **messages** — request/response wrappers
- **operations** — named methods the client can call
- **binding** — SOAP over HTTP, including the `SOAPAction` for each operation
- **service** — the actual endpoint URL

A typical SOAP HTTP call looks like this:

| Piece | Value in this app |
|---|---|
| Method | `POST` |
| Content-Type | `text/xml; charset=utf-8` |
| SOAPAction header | operation name (see [WSDL](#this-projects-wsdl)) |
| Body | SOAP envelope with the operation XML |

### SOAP vs REST (short)

| | SOAP | REST |
|---|---|---|
| Payload | XML envelope | Usually JSON |
| Contract | WSDL (strict schema) | Often OpenAPI / informal |
| Errors | SOAP Fault inside the envelope | HTTP status + JSON body |
| Operations | Named methods (`GetPatientHistory`) | Resources + HTTP verbs |
| Best fit | Enterprise / legacy / healthcare | New public mobile APIs |

REST is usually the better default for new mobile APIs. SOAP is still common where hospitals, banks, and governments already expose a WSDL and will not rewrite it.

```mermaid
Flowchart LR
    %% User Request Flow (Downwards/Right)
    Screen[Flutter Screen] -->|"User Action / Event"| Controller[Controller / State Manager]
    Controller -->|"Fetch Request"| Repository
    Repository -->|"Fetch Data"| DataSource[SOAP Data Source / Resource]
    DataSource -->|"Construct XML"| ApiHelper
    ApiHelper -->|"POST XML Envelope"| Beeceptor[Beeceptor / SOAP API]

    %% Response Flow (Upwards/Left)
    Beeceptor -->|"XML Response"| ApiHelper
    ApiHelper -->|"Parse XML to Models"| Models[Dart Models]
    Models -->|"Return Models / Entities"| Repository
    Repository -->|"Return Domain Models / State"| Controller
    Controller -->|"Emit UI State"| Screen
```

---

## Best use cases for SOAP

Use SOAP when the other system already speaks it, or when the industry still requires a formal XML contract:

- **Healthcare and insurance** — EHR systems, HL7-related services, national health records
- **Government and public sector** — tax, identity, licensing portals that publish a WSDL
- **Banking and payments** — core banking, card networks, settlement APIs
- **Enterprise ERP** — SAP, Oracle, and similar systems with SOAP bindings
- **Legacy integration** — the only available API is a SOAP endpoint from a decade ago
- **Strict contracts** — you need schema-validated operations, WS-Security, or guaranteed method names

This app exists because many hospital systems still expose patient history over SOAP. For a greenfield public API, prefer REST or GraphQL.

---

## This project's WSDL

File: [`WSDL.xml`](WSDL.xml)

| | |
|---|---|
| Service | `PatientHistoryService` |
| Namespace | `http://example.com/patient` |
| Style | SOAP 1.1 document/literal |
| WSDL address | `http://localhost:8080/patient-history` (replace with Beeceptor) |

**Types**

- `Patient` — id, firstName, lastName, dateOfBirth, gender, bloodType
- `Condition` — conditionId, name, diagnosedDate, status, notes
- `Medication` — medicationId, name, dosage, frequency, startDate, endDate, prescribingDoctor
- `PatientHistory` — patient + conditions + medications + allergies

**Operations**

| Operation | SOAPAction (WSDL) | Request | Response |
|---|---|---|---|
| `SearchPatients` | `http://example.com/patient/SearchPatients` | `searchTerm`, optional `maxResults` | list of patients |
| `GetPatientHistory` | `http://example.com/patient/GetPatientHistory` | `patientId` | full history |
| `AddCondition` | `http://example.com/patient/AddCondition` | `patientId` + condition | `success`, `message` |
| `UpdateMedication` | `http://example.com/patient/UpdateMedication` | `patientId` + medication | `success`, `message` |

The Flutter client currently sends the **short** SOAPAction (`SearchPatients`, `GetPatientHistory`, …). Beeceptor can match that from the SOAP body operation name. See [Troubleshooting](#troubleshooting).

---

## Mock the APIs on Beeceptor

Use [`WSDL.xml`](WSDL.xml) so Beeceptor knows the four operations. Then override the generated responses so the XML nesting matches this app's parsers.

### 1. Create a SOAP mock from the WSDL

1. Create a free account at [beeceptor.com](https://beeceptor.com).
2. Create a **SOAP mock server from WSDL** ([docs](https://beeceptor.com/docs/soap-server-from-wsdl/)).
3. Upload this repo's `WSDL.xml` (`.xml` is accepted). You can also paste a public URL to the file.
4. Copy the mock base URL, for example:

   ```text
   https://your-endpoint.mock.beeceptor.com
   ```

5. Confirm these operations appear on the dashboard:
   - `SearchPatients`
   - `GetPatientHistory`
   - `AddCondition`
   - `UpdateMedication`
6. Optional check: open `{baseUrl}?wsdl` in a browser. Beeceptor should return the spec.

Paste that URL into `SoapConfig.baseUrl` (see [Setup](#setup-this-flutter-app)).

### 2. Why custom mock rules

Beeceptor AI generates envelopes from the WSDL. This app's Dart parsers expect a slightly nested list shape:

- Search: repeating `<patients>` elements (each one is a patient)
- History: `<conditions><condition/>…</conditions>`, `<medications><medication/>…</medications>`, and `<allergies>` with child elements

Override the AI payloads with the envelopes below so search, profile, and history screens parse correctly.

### 3. Matching rules

Create one mock rule per operation:

- Method: `POST`
- Path: `/` (or the path Beeceptor assigned)
- Filter: **SOAPAction matches** the short name (`SearchPatients`, …) **or** the full WSDL URI
- Beeceptor also falls back to the operation name inside the SOAP body, which this app always sends
- Response status: `200`
- Response header: `Content-Type: text/xml; charset=utf-8`

### 4. Request envelope this app sends

[`ApiHelper`](lib/core/api/api_helper.dart) wraps every operation body like this:

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <!-- operation XML from the resource -->
  </soap:Body>
</soap:Envelope>
```

Headers:

```http
Content-Type: text/xml; charset=utf-8
SOAPAction: SearchPatients
```

(`SOAPAction` is the short operation name from the resource, not the full WSDL URI.)

### 5. Paste-ready mock responses

Use these as the **response body** for each Beeceptor rule. They match:

- [`PatientSoapResource`](lib/features/home/data/resources/patient_soap_resource.dart) — repeating `<patients>`
- [`PatientHistory.fromXml`](lib/features/patient_profile/data/models/patient_history.dart) — nested `<condition>` / `<medication>` lists

#### SearchPatients

**Request body (what the app sends inside the envelope)**

```xml
<SearchPatientsRequest>
  <searchTerm>john</searchTerm>
  <maxResults>20</maxResults>
</SearchPatientsRequest>
```

**Mock response**

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SearchPatientsResponse xmlns="http://example.com/patient">
      <patients>
        <id>p-001</id>
        <firstName>John</firstName>
        <lastName>Carter</lastName>
        <dateOfBirth>1984-03-12</dateOfBirth>
        <gender>Male</gender>
        <bloodType>O+</bloodType>
      </patients>
      <patients>
        <id>p-002</id>
        <firstName>Jane</firstName>
        <lastName>Okoro</lastName>
        <dateOfBirth>1991-07-22</dateOfBirth>
        <gender>Female</gender>
        <bloodType>A-</bloodType>
      </patients>
    </SearchPatientsResponse>
  </soap:Body>
</soap:Envelope>
```

#### GetPatientHistory

**Request body**

```xml
<GetPatientHistoryRequest xmlns="http://example.com/patient">
  <patientId>2b953399-8ac6-4806-a4cf-177c0207afd7</patientId>
</GetPatientHistoryRequest>
```

The resource currently hardcodes that `patientId`. The mock can ignore the id and always return this history.

**Mock response**

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetPatientHistoryResponse xmlns="http://example.com/patient">
      <history>
        <patient>
          <id>p-001</id>
          <firstName>John</firstName>
          <lastName>Carter</lastName>
          <dateOfBirth>1984-03-12</dateOfBirth>
          <gender>Male</gender>
          <bloodType>O+</bloodType>
        </patient>
        <conditions>
          <condition>
            <conditionId>c-101</conditionId>
            <name>Type 2 Diabetes</name>
            <diagnosedDate>2019-05-14</diagnosedDate>
            <status>Chronic</status>
            <notes>Managed with metformin</notes>
          </condition>
          <condition>
            <conditionId>c-102</conditionId>
            <name>Seasonal allergy</name>
            <diagnosedDate>2016-04-01</diagnosedDate>
            <status>Active</status>
          </condition>
        </conditions>
        <medications>
          <medication>
            <medicationId>m-201</medicationId>
            <name>Metformin</name>
            <dosage>500 mg</dosage>
            <frequency>Twice daily</frequency>
            <startDate>2019-05-20</startDate>
            <prescribingDoctor>Dr. Adeyemi</prescribingDoctor>
          </medication>
        </medications>
        <allergies>
          <allergy>Penicillin</allergy>
          <allergy>Peanuts</allergy>
        </allergies>
      </history>
    </GetPatientHistoryResponse>
  </soap:Body>
</soap:Envelope>
```

#### AddCondition

**Request body**

```xml
<AddConditionRequest>
  <patientId>p-001</patientId>
  <condition>
    <conditionId>...</conditionId>
    <name>Hypertension</name>
    <diagnosedDate>2024-01-10</diagnosedDate>
    <status>Active</status>
    <notes>Monitor BP weekly</notes>
  </condition>
</AddConditionRequest>
```

**Mock response**

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <AddConditionResponse xmlns="http://example.com/patient">
      <success>true</success>
      <message>Condition added</message>
    </AddConditionResponse>
  </soap:Body>
</soap:Envelope>
```

#### UpdateMedication

**Request body**

```xml
<UpdateMedicationRequest>
  <patientId>p-001</patientId>
  <medication>
    <medicationId>m-201</medicationId>
    <name>Metformin</name>
    <dosage>1000 mg</dosage>
    <frequency>Once daily</frequency>
    <startDate>2019-05-20</startDate>
    <prescribingDoctor>Dr. Adeyemi</prescribingDoctor>
  </medication>
</UpdateMedicationRequest>
```

**Mock response**

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <UpdateMedicationResponse xmlns="http://example.com/patient">
      <success>true</success>
      <message>Medication updated</message>
    </UpdateMedicationResponse>
  </soap:Body>
</soap:Envelope>
```

Optional: add a second rule that returns a SOAP Fault so you can test error handling:

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>Patient not found</faultstring>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>
```

`ApiHelper` throws if it finds a `Fault` element.

---

## How to integrate SOAP with Flutter

This app does not use a SOAP code generator. It posts XML with `http`, parses it with `xml`, and maps tags to Dart models.

```
Screen → Controller → Repository → SOAP Resource → ApiHelper → Beeceptor
```

| Layer | Role | Where |
|---|---|---|
| `SoapConfig` | Base URL and `Content-Type: text/xml` | [`lib/core/soap/soap_config.dart`](lib/core/soap/soap_config.dart) |
| `ApiHelper` | Build SOAP 1.1 envelope, POST, parse XML, throw on Fault | [`lib/core/api/api_helper.dart`](lib/core/api/api_helper.dart) |
| SOAP resource | Build operation XML, call `postSoap`, map XML → models | `features/*/data/resources/` |
| Repository | Hide SOAP errors behind a user-facing message | `features/*/data/repositories/` |
| Controller | Load/save state for a screen (`provider`) | `features/*/ui/controllers/` |
| Screen / widgets | UI only | `features/*/ui/screens/` and `widgets/` |

**Resource pattern**

1. Build the inner XML (`<SearchPatientsRequest>…</SearchPatientsRequest>`).
2. Call `apiHelper.postSoap(soapAction: 'SearchPatients', bodyInnerXml: …)`.
3. Find the response element (`SearchPatientsResponse`, namespace-agnostic).
4. Map child tags with `Patient.fromXml` / `Condition.fromXml` / `Medication.fromXml`.
5. For writes, `Condition.toXml()` / `Medication.toXml()` serialize the form back to XML.

**Feature map**

| Feature | SOAP operations | Screens |
|---|---|---|
| `home` | `SearchPatients` | patient search |
| `patient_profile` | `GetPatientHistory`, `AddCondition`, `UpdateMedication` | profile, history, add condition, manage medications |

```
lib/
  core/
    api/api_helper.dart
    soap/soap_config.dart
    helpers/route_helper.dart
  features/
    home/
      data/   models, repositories, resources
      ui/     screens, widgets, controllers
    patient_profile/
      data/   models, repositories, resources
      ui/     screens, widgets, controllers
  main.dart
```

`main.dart` wires resources → repositories → `MultiProvider`, then `MaterialApp` with `RouteHelper`.

---

## Setup this Flutter app

1. Install the Flutter SDK **3.11+** and confirm the toolchain:

   ```bash
   flutter doctor
   ```

2. Open this project and fetch packages:

   ```bash
   flutter pub get
   ```

3. Paste your Beeceptor URL into [`lib/core/soap/soap_config.dart`](lib/core/soap/soap_config.dart). It currently says `'your_base_url'`:

   ```dart
   static const String baseUrl = 'https://your-endpoint.mock.beeceptor.com';
   ```

4. **Android:** debug and profile already declare `INTERNET`. For a release build, add this to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:

   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

5. **iOS:** Beeceptor is HTTPS, so App Transport Security needs no extra change.

6. Run:

   ```bash
   flutter run
   ```

### Try it

1. On **Patient Records**, type a search term (the mock ignores the term if you used the sample `SearchPatients` response).
2. Open a patient → **profile**.
3. Open **medical history**, **add condition**, or **manage medications**.
4. Watch Beeceptor's request log: each screen should POST a SOAP envelope with the matching operation.

---

## Troubleshooting

| Symptom | What to check |
|---|---|
| Request never leaves the device / invalid URL | `SoapConfig.baseUrl` is still `'your_base_url'`. Paste the Beeceptor HTTPS URL. |
| 404 or empty Beeceptor log | POST to the mock **base URL**. Confirm the rule path is `/` (or whatever Beeceptor shows). |
| Wrong mock rule fires / no match | The app sends short SOAPActions (`GetPatientHistory`). WSDL SOAPActions are full URIs (`http://example.com/patient/GetPatientHistory`). Match the short name, or rely on Beeceptor's body-operation fallback, or add both rules. |
| Search returns nothing / parse error | Response must include `<SearchPatientsResponse>` and repeating `<patients>` elements with `id`, `firstName`, `lastName`, `dateOfBirth`, `gender`, `bloodType`. Dates must be ISO (`1984-03-12`). |
| History screen fails | Use nested lists: `<conditions><condition/>…</conditions>` and `<medications><medication/>…</medications>`, not repeating sibling `<conditions>` tags from a strict WSDL dump. |
| History ignores the patient you tapped | [`HistorySoapResource.getPatientHistory`](lib/features/patient_profile/data/resources/history_soap_resource.dart) currently hardcodes `patientId`. The mock can ignore it and always return the sample history. |
| SOAP Fault | `ApiHelper` throws if the XML contains `Fault`. Check the Beeceptor response body. |
| Android release cannot reach the network | Add `INTERNET` to the **main** `AndroidManifest.xml`. |
