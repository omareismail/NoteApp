## Pricing Request / Response API (Quote)

### Authentication
- **Header**: `X-API-KEY: <secret>` (required)
- **Recommended headers** (optional but strongly suggested):
  - `X-Request-Id: <uuid>` (trace/correlation)
  - `Idempotency-Key: <uuid>` (avoid duplicate quotes on retries)

### Endpoint
- **Method**: `POST`
- **Path**: `/api/v1/pricing/requests`
- **Content-Type**:
  - `application/json` (if attachments are sent as Base64 in JSON)
  - `multipart/form-data` (if attachments are sent as real files)

---

## Request Body (JSON)

### Shape
```json
{
  "customerInformation": {
    "typeId": 1,
    "type": "INDIVIDUAL",
    "fullName": "Ahmed Jamal",
    "documentId": 1,
    "document": "PASSPORT",
    "documentValue": "123695847",
    "dateOfBirth": "2000-12-14"
  },
  "insuranceInformation": {
    "insuranceStartDate": "2025-12-15",
    "insuranceEndDate": "2026-12-14",
    "licAreaId": 1,
    "licArea": "WEST_BANK",
    "insuranceServiceId": 2,
    "insuranceService": "MANDATORY_THIRDPARTY",

    "isVehicleMortgaged": true,
    "vehicleMortgagedTypeId": 1,
    "vehicleMortgagedType": "BANK",
    "vehicleMortgageId": 1,
    "vehicleMortgage": "POB",

    "isHasAccidanteBefor": true,
    "totalDamageCost": 2000,
    "accidentDiscription": "Bla la la…"
  },
  "vehicleInformation": {
    "chassisNumber": "12589632147852369",
    "motorNumber": "1236987",
    "motorNumberCode": "P",

    "fuelTypeId": 1,
    "fuelType": "SOLAR",

    "engineSize": 1500,
    "numberOfSeats": 6,
    "numberOfDrivers": 1,
    "weights": 2,

    "motorCategoryId": 1,
    "motorCategory": "PRIVATE_CAR",
    "motorSubCategoryId": 1,
    "motorSubCategory": "PRIVATE_CAR",

    "motorTypeId": 1,
    "motorType": "KIA",
    "motorModelId": 2,
    "motorModel": "SORENTO",

    "motorValue": 20000,
    "makeYear": 2022
  },
  "attachmentInformation": [
    {
      "attachmentId": 1,
      "attachment": "VEHICLE_PREVIEW",
      "attachmentValueBase64": "<base64>",
      "fileName": "vehicle.jpg",
      "mimeType": "image/jpeg"
    }
  ],
  "driversInformation": [
    {
      "driverName": "Omar Ismail",
      "documentId": 1,
      "document": "PASSPORT",
      "documentValue": "12589634",
      "dateOfBirth": "2001-08-12",
      "licenseObtainingDate": "2015-08-12"
    }
  ],

  "meta": {
    "callbackUrl": "https://client.example.com/insurance/pricing/callback",
    "language": "ar",
    "channel": "MOBILE_APP"
  },
  "consent": {
    "termsAccepted": true,
    "privacyAccepted": true,
    "consentAt": "2025-12-15T09:00:00Z"
  }
}
```

### Notes
- **Dates**: use ISO date strings `YYYY-MM-DD` (example: `2025-12-15`).
- **Datetimes**: use RFC3339/ISO `YYYY-MM-DDTHH:mm:ssZ` (example: `2025-12-15T09:00:00Z`).
- **Typo compatibility**: request field `isHasAccidanteBefor` and `accidentDiscription` are kept as-is (to match your input). If you want, we can add server-side aliasing to accept corrected names too.

---

## Request Schema (JSON Schema – Draft 2020-12)

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://example.com/schemas/pricing-request.json",
  "type": "object",
  "additionalProperties": false,
  "required": [
    "customerInformation",
    "insuranceInformation",
    "vehicleInformation",
    "driversInformation"
  ],
  "properties": {
    "customerInformation": {
      "type": "object",
      "additionalProperties": false,
      "required": [
        "typeId",
        "type",
        "fullName",
        "documentId",
        "document",
        "documentValue",
        "dateOfBirth"
      ],
      "properties": {
        "typeId": { "type": "integer", "minimum": 1 },
        "type": { "type": "string", "enum": ["INDIVIDUAL", "COMPANY"] },
        "fullName": { "type": "string", "minLength": 2, "maxLength": 200 },
        "documentId": { "type": "integer", "minimum": 1 },
        "document": {
          "type": "string",
          "enum": ["PASSPORT", "NATIONAL_ID", "DRIVER_LICENSE", "RESIDENCY"]
        },
        "documentValue": { "type": "string", "minLength": 3, "maxLength": 50 },
        "dateOfBirth": { "type": "string", "format": "date" }
      }
    },

    "insuranceInformation": {
      "type": "object",
      "additionalProperties": false,
      "required": [
        "insuranceStartDate",
        "insuranceEndDate",
        "licAreaId",
        "licArea",
        "insuranceServiceId",
        "insuranceService",
        "isVehicleMortgaged",
        "isHasAccidanteBefor"
      ],
      "properties": {
        "insuranceStartDate": { "type": "string", "format": "date" },
        "insuranceEndDate": { "type": "string", "format": "date" },

        "licAreaId": { "type": "integer", "minimum": 1 },
        "licArea": {
          "type": "string",
          "enum": ["WEST_BANK", "GAZA", "JERUSALEM", "OTHER"]
        },

        "insuranceServiceId": { "type": "integer", "minimum": 1 },
        "insuranceService": {
          "type": "string",
          "enum": [
            "MANDATORY_THIRDPARTY",
            "COMPREHENSIVE",
            "THIRDPARTY_PLUS"
          ]
        },

        "isVehicleMortgaged": { "type": "boolean" },
        "vehicleMortgagedTypeId": { "type": "integer", "minimum": 1 },
        "vehicleMortgagedType": { "type": "string", "enum": ["BANK", "COMPANY", "OTHER"] },
        "vehicleMortgageId": { "type": "integer", "minimum": 1 },
        "vehicleMortgage": { "type": "string", "minLength": 1, "maxLength": 100 },

        "isHasAccidanteBefor": { "type": "boolean" },
        "totalDamageCost": { "type": "number", "minimum": 0 },
        "accidentDiscription": { "type": "string", "maxLength": 2000 }
      },
      "allOf": [
        {
          "if": {
            "properties": { "isVehicleMortgaged": { "const": true } },
            "required": ["isVehicleMortgaged"]
          },
          "then": {
            "required": [
              "vehicleMortgagedTypeId",
              "vehicleMortgagedType",
              "vehicleMortgageId",
              "vehicleMortgage"
            ]
          }
        },
        {
          "if": {
            "properties": { "isHasAccidanteBefor": { "const": true } },
            "required": ["isHasAccidanteBefor"]
          },
          "then": { "required": ["totalDamageCost", "accidentDiscription"] }
        }
      ]
    },

    "vehicleInformation": {
      "type": "object",
      "additionalProperties": false,
      "required": [
        "chassisNumber",
        "motorNumber",
        "motorNumberCode",
        "fuelTypeId",
        "fuelType",
        "engineSize",
        "numberOfSeats",
        "numberOfDrivers",
        "weights",
        "motorCategoryId",
        "motorCategory",
        "motorSubCategoryId",
        "motorSubCategory",
        "motorTypeId",
        "motorType",
        "motorModelId",
        "motorModel",
        "motorValue",
        "makeYear"
      ],
      "properties": {
        "chassisNumber": { "type": "string", "minLength": 5, "maxLength": 50 },
        "motorNumber": { "type": "string", "minLength": 1, "maxLength": 50 },
        "motorNumberCode": { "type": "string", "minLength": 1, "maxLength": 10 },

        "fuelTypeId": { "type": "integer", "minimum": 1 },
        "fuelType": { "type": "string", "enum": ["GASOLINE", "DIESEL", "ELECTRIC", "HYBRID", "SOLAR"] },

        "engineSize": { "type": "integer", "minimum": 0 },
        "numberOfSeats": { "type": "integer", "minimum": 1 },
        "numberOfDrivers": { "type": "integer", "minimum": 1 },
        "weights": { "type": "number", "minimum": 0 },

        "motorCategoryId": { "type": "integer", "minimum": 1 },
        "motorCategory": { "type": "string", "enum": ["PRIVATE_CAR", "COMMERCIAL", "TRUCK", "BUS", "MOTORCYCLE"] },

        "motorSubCategoryId": { "type": "integer", "minimum": 1 },
        "motorSubCategory": { "type": "string" },

        "motorTypeId": { "type": "integer", "minimum": 1 },
        "motorType": { "type": "string", "minLength": 1, "maxLength": 100 },

        "motorModelId": { "type": "integer", "minimum": 1 },
        "motorModel": { "type": "string", "minLength": 1, "maxLength": 100 },

        "motorValue": { "type": "number", "minimum": 0 },
        "makeYear": { "type": "integer", "minimum": 1900, "maximum": 2100 }
      }
    },

    "attachmentInformation": {
      "type": "array",
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["attachmentId", "attachment"],
        "properties": {
          "attachmentId": { "type": "integer", "minimum": 1 },
          "attachment": { "type": "string", "enum": ["VEHICLE_PREVIEW", "VEHICLE_IMAGES", "DRIVER_LICENSE", "ID_DOCUMENT", "OTHER"] },
          "attachmentValueBase64": { "type": "string" },
          "fileName": { "type": "string", "maxLength": 255 },
          "mimeType": { "type": "string", "maxLength": 100 }
        }
      }
    },

    "driversInformation": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": [
          "driverName",
          "documentId",
          "document",
          "documentValue",
          "dateOfBirth",
          "licenseObtainingDate"
        ],
        "properties": {
          "driverName": { "type": "string", "minLength": 2, "maxLength": 200 },
          "documentId": { "type": "integer", "minimum": 1 },
          "document": {
            "type": "string",
            "enum": ["PASSPORT", "NATIONAL_ID", "DRIVER_LICENSE", "RESIDENCY"]
          },
          "documentValue": { "type": "string", "minLength": 3, "maxLength": 50 },
          "dateOfBirth": { "type": "string", "format": "date" },
          "licenseObtainingDate": { "type": "string", "format": "date" }
        }
      }
    },

    "meta": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "callbackUrl": { "type": "string", "format": "uri" },
        "language": { "type": "string", "maxLength": 10 },
        "channel": { "type": "string", "maxLength": 50 }
      }
    },

    "consent": {
      "type": "object",
      "additionalProperties": false,
      "required": ["termsAccepted", "privacyAccepted"],
      "properties": {
        "termsAccepted": { "type": "boolean" },
        "privacyAccepted": { "type": "boolean" },
        "consentAt": { "type": "string", "format": "date-time" }
      }
    }
  }
}
```

---

## Attachments (Multipart Option)

If you want to upload **real files** instead of Base64:

- **Content-Type**: `multipart/form-data`
- **Parts**:
  - `payload` (JSON string) containing everything **except** `attachmentValueBase64`
  - `files[]` (one or more file parts)

Example parts mapping:
- `payload.attachmentInformation[0]` contains metadata (`attachmentId`, `attachment`, `fileName`, `mimeType`)
- `files[0]` contains the actual file bytes

---

## Response

### Wrapper (always)
```json
{
  "requestNo": "Q-2025-000123",
  "insuranceCompanyId": 5,
  "status": "PRICED",
  "data": {},
  "errors": [],
  "meta": {
    "referenceNo": "INS-889911",
    "responseAt": "2025-01-10T11:30:00Z"
  }
}
```

### Status values
- `PRICED`
- `PENDING_APPROVAL`
- `NEED_MORE_INFO`
- `REJECTED`
- `ERROR`

### Response examples by status

#### 1) PRICED
```json
{
  "requestNo": "Q-2025-000123",
  "insuranceCompanyId": 5,
  "status": "PRICED",
  "data": {
    "price": { "amount": 1350.0, "currency": "ILS" },
    "coverage": { "type": "COMPREHENSIVE", "deductible": 500 },
    "validUntil": "2025-01-20"
  },
  "errors": [],
  "meta": { "referenceNo": "INS-889911", "responseAt": "2025-01-10T11:30:00Z" }
}
```

#### 2) PENDING_APPROVAL
```json
{
  "requestNo": "Q-2025-000123",
  "insuranceCompanyId": 5,
  "status": "PENDING_APPROVAL",
  "data": {
    "estimatedResponseTimeHours": 24,
    "approval": {
      "type": "MANUAL_REVIEW",
      "expiresAt": "2025-01-11T11:30:00Z",
      "notes": "Underwriter review required"
    }
  },
  "errors": [],
  "meta": { "referenceNo": "INS-889911", "responseAt": "2025-01-10T11:30:00Z" }
}
```

#### 3) NEED_MORE_INFO
```json
{
  "requestNo": "Q-2025-000123",
  "insuranceCompanyId": 5,
  "status": "NEED_MORE_INFO",
  "data": {
    "requiredItems": [
      {
        "code": "VEHICLE_IMAGES",
        "description": "Vehicle images required",
        "mandatory": true
      }
    ]
  },
  "errors": [],
  "meta": { "referenceNo": "INS-889911", "responseAt": "2025-01-10T11:30:00Z" }
}
```

#### 4) REJECTED
```json
{
  "requestNo": "Q-2025-000123",
  "insuranceCompanyId": 5,
  "status": "REJECTED",
  "data": {},
  "errors": [
    {
      "code": "VEHICLE_AGE_NOT_ALLOWED",
      "message": "Vehicle age exceeds underwriting limits",
      "severity": "BUSINESS"
    }
  ],
  "meta": { "referenceNo": "INS-889911", "responseAt": "2025-01-10T11:30:00Z" }
}
```

#### 5) ERROR
```json
{
  "requestNo": "Q-2025-000123",
  "insuranceCompanyId": 5,
  "status": "ERROR",
  "data": {},
  "errors": [
    {
      "code": "MAPPING_ERROR",
      "message": "Vehicle category mapping not found",
      "severity": "TECHNICAL"
    }
  ],
  "meta": { "referenceNo": "INS-889911", "responseAt": "2025-01-10T11:30:00Z" }
}
```

---

## Recommended “Approval / Controls” Additions

If you want a stronger enterprise-ready flow, these are safe to add without breaking your current structure:

- **Idempotency**: `Idempotency-Key` header (recommended).
- **Callback**: `meta.callbackUrl` so backend can push updates for `PENDING_APPROVAL` / `NEED_MORE_INFO`.
- **Consent**: `consent.termsAccepted/privacyAccepted/consentAt` for legal compliance.
- **Approval object** (response): `data.approval` when `status = PENDING_APPROVAL` (manual review, OTP, or external approval URL).
