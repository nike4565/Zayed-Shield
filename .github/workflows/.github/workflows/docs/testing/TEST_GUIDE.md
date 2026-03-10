# 🧪 CyberGuard AI - دليل الاختبارات الشامل
permissions:
  contents: read


**النسخة**: 2.0 | **آخر تحديث**: يناير 2070

---

## 📑 جدول المحتويات

1. [استراتيجية الاختبار](#استراتيجية-الاختبار)
2. [Unit Tests](#unit-tests)
3. [Integration Tests](#integration-tests)
4. [AI Model Tests](#ai-model-tests)
5. [Security Tests](#security-tests)
6. [Performance Tests](#performance-tests)
7. [E2E Tests](#end-to-end-tests)

---

## 🎯 استراتيجية الاختبار

### Test Pyramid

```
┌──────────────── Test Pyramid ─────────────────┐
│                                                 │
│                   ▲                            │
│                  ╱ ╲                           │
│                 ╱   ╲    E2E Tests             │
│                ╱     ╲   (5%)                  │
│               ╱───────╲                        │
│              ╱         ╲                       │
│             ╱           ╲  Integration Tests   │
│            ╱             ╲ (25%)               │
│           ╱───────────────╲                    │
│          ╱                 ╲                   │
│         ╱                   ╲  Unit Tests      │
│        ╱                     ╲ (70%)           │
│       ╱───────────────────────╲                │
│                                                 │
│  Principles:                                   │
│  • Fast feedback loop                          │
│  • High code coverage (>90%)                   │
│  • Automated execution                         │
│  • CI/CD integration                           │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Testing Tools Stack

```yaml
Unit Testing:
  - pytest (Python)
  - Jest (JavaScript)
  - Go test (Go)

Integration Testing:
  - pytest + testcontainers
  - Supertest (API)
  - Postman Collections

E2E Testing:
  - Playwright
  - Cypress
  - Selenium (legacy)

Performance Testing:
  - k6
  - Locust
  - Apache JMeter

Security Testing:
  - OWASP ZAP
  - Burp Suite
  - Trivy
  - SonarQube

AI/ML Testing:
  - MLflow
  - TensorBoard
  - Evidently AI (drift detection)
```

---

## 🔬 Unit Tests

### Python Unit Tests (pytest)

```python
# tests/unit/test_malware_detector.py

import pytest
from cyberguard.ml.malware_detector import MalwareDetector
import numpy as np

@pytest.fixture
def detector():
    """تحضير detector للاختبار"""
    return MalwareDetector(model_path="models/test_model.pth")

class TestMalwareDetector:
    
    def test_initialization(self, detector):
        """اختبار التهيئة الصحيحة"""
        assert detector is not None
        assert detector.model is not None
        assert detector.device in ['cpu', 'cuda']
    
    def test_preprocess_file(self, detector, tmp_path):
        """اختبار معالجة الملف"""
        # إنشاء ملف اختبار
        test_file = tmp_path / "test_malware.exe"
        test_file.write_bytes(b"MZ\x90\x00" + b"\x00" * 100)
        
        # معالجة
        features = detector.preprocess(test_file)
        
        # التحقق
        assert features is not None
        assert isinstance(features, np.ndarray)
        assert features.shape[0] == detector.feature_size
    
    @pytest.mark.parametrize("file_content,expected", [
        (b"MZ\x90\x00" + b"\x00" * 1000, True),  # PE file
        (b"#!/bin/bash\necho 'test'", False),    # Bash script
        (b"Hello World", False),                 # Text file
    ])
    def test_detect_malware(self, detector, file_content, expected, tmp_path):
        """اختبار الكشف مع حالات متعددة"""
        test_file = tmp_path / "sample"
        test_file.write_bytes(file_content)
        
        result = detector.detect(test_file)
        
        assert 'is_malicious' in result
        assert 'confidence' in result
        assert 0 <= result['confidence'] <= 1
    
    def test_batch_detection(self, detector, tmp_path):
        """اختبار الكشف الجماعي"""
        # إنشاء ملفات متعددة
        files = []
        for i in range(10):
            file = tmp_path / f"sample_{i}.bin"
            file.write_bytes(b"\x00" * (100 * i))
            files.append(file)
        
        results = detector.detect_batch(files)
        
        assert len(results) == 10
        assert all('is_malicious' in r for r in results)
    
    def test_invalid_file(self, detector):
        """اختبار التعامل مع ملف غير صالح"""
        with pytest.raises(FileNotFoundError):
            detector.detect("nonexistent_file.exe")
    
    def test_model_accuracy(self, detector):
        """اختبار دقة النموذج على بيانات اختبار"""
        from cyberguard.test_data import load_test_dataset
        
        X_test, y_test = load_test_dataset()
        predictions = detector.predict_batch(X_test)
        accuracy = np.mean(predictions == y_test)
        
        # يجب أن تكون الدقة > 95%
        assert accuracy > 0.95, f"Accuracy {accuracy} is below threshold"
    
    def test_performance(self, detector, tmp_path, benchmark):
        """اختبار الأداء"""
        test_file = tmp_path / "perf_test.bin"
        test_file.write_bytes(b"\x00" * 10000)
        
        # يجب أن يكتمل في أقل من 100ms
        result = benchmark(detector.detect, test_file)
        assert result is not None
    
    def test_memory_leak(self, detector, tmp_path):
        """اختبار تسرب الذاكرة"""
        import tracemalloc
        
        test_file = tmp_path / "memory_test.bin"
        test_file.write_bytes(b"\x00" * 10000)
        
        tracemalloc.start()
        
        # تشغيل 1000 مرة
        for _ in range(1000):
            detector.detect(test_file)
        
        current, peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()
        
        # لا يجب أن يتجاوز 100MB
        assert peak < 100 * 1024 * 1024

# Coverage Report
"""
Run tests with coverage:
    pytest --cov=cyberguard --cov-report=html --cov-report=term
    
Target: >90% code coverage
"""
```

### JavaScript Unit Tests (Jest)

```javascript
// tests/unit/api.test.js

const request = require('supertest');
const app = require('../../src/app');
const { generateToken } = require('../../src/utils/auth');

describe('API Endpoints', () => {
  let authToken;
  
  beforeAll(() => {
    authToken = generateToken({ userId: 'test-user' });
  });
  
  describe('POST /api/v2/threats/scan', () => {
    test('should scan file successfully', async () => {
      const response = await request(app)
        .post('/api/v2/threats/scan')
        .set('Authorization', `Bearer ${authToken}`)
        .attach('file', 'tests/fixtures/sample.exe')
        .expect(200);
      
      expect(response.body).toHaveProperty('scan_id');
      expect(response.body).toHaveProperty('threat_level');
      expect(response.body.status).toBe('completed');
    });
    
    test('should reject unauthorized requests', async () => {
      await request(app)
        .post('/api/v2/threats/scan')
        .attach('file', 'tests/fixtures/sample.exe')
        .expect(401);
    });
    
    test('should reject files over size limit', async () => {
      // Create 100MB file
      const largeBuffer = Buffer.alloc(100 * 1024 * 1024);
      
      const response = await request(app)
        .post('/api/v2/threats/scan')
        .set('Authorization', `Bearer ${authToken}`)
        .attach('file', largeBuffer, 'large.bin')
        .expect(400);
      
      expect(response.body.error).toContain('size limit');
    });
  });
  
  describe('GET /api/v2/threats/intelligence', () => {
    test('should return threat intel for valid IOC', async () => {
      const response = await request(app)
        .get('/api/v2/threats/intelligence')
        .query({ ioc: '203.0.113.45' })
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);
      
      expect(response.body).toHaveProperty('reputation_score');
      expect(response.body).toHaveProperty('threat_level');
    });
  });
});

// Performance test
describe('Performance Tests', () => {
  test('API should respond within 200ms', async () => {
    const start = Date.now();
    
    await request(app)
      .get('/api/v2/health')
      .expect(200);
    
    const duration = Date.now() - start;
    expect(duration).toBeLessThan(200);
  });
});
```

---

## 🔗 Integration Tests

### Database Integration Tests

```python
# tests/integration/test_database.py

import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from cyberguard.models import Base, Threat, IOC, Incident
import testcontainers.postgres as postgres

@pytest.fixture(scope="module")
def db_engine():
    """تشغيل PostgreSQL في container"""
    with postgres.PostgresContainer("postgres:16") as pg:
        engine = create_engine(pg.get_connection_url())
        Base.metadata.create_all(engine)
        yield engine
        Base.metadata.drop_all(engine)

@pytest.fixture
def db_session(db_engine):
    """إنشاء session للاختبار"""
    Session = sessionmaker(bind=db_engine)
    session = Session()
    yield session
    session.rollback()
    session.close()

class TestThreatModel:
    
    def test_create_threat(self, db_session):
        """اختبار إنشاء تهديد جديد"""
        threat = Threat(
            file_hash="abc123def456",
            threat_type="ransomware",
            severity_level="critical",
            confidence_score=0.98,
            malware_family="WannaCry-2070"
        )
        
        db_session.add(threat)
        db_session.commit()
        
        # التحقق
        saved = db_session.query(Threat).filter_by(
            file_hash="abc123def456"
        ).first()
        
        assert saved is not None
        assert saved.threat_type == "ransomware"
        assert saved.confidence_score == 0.98
    
    def test_query_threats_by_family(self, db_session):
        """اختبار البحث حسب عائلة البرمجيات الخبيثة"""
        # إضافة بيانات اختبار
        for i in range(10):
            threat = Threat(
                file_hash=f"hash_{i}",
                threat_type="trojan",
                severity_level="high",
                malware_family="Zeus" if i % 2 == 0 else "Emotet"
            )
            db_session.add(threat)
        
        db_session.commit()
        
        # البحث
        zeus_threats = db_session.query(Threat).filter_by(
            malware_family="Zeus"
        ).all()
        
        assert len(zeus_threats) == 5
    
    def test_threat_relationships(self, db_session):
        """اختبار العلاقات بين الجداول"""
        # إنشاء threat مع iocs
        threat = Threat(
            file_hash="test123",
            threat_type="malware"
        )
        
        ioc1 = IOC(ioc_type="ip", ioc_value="192.168.1.100")
        ioc2 = IOC(ioc_type="domain", ioc_value="evil.com")
        
        threat.iocs.extend([ioc1, ioc2])
        db_session.add(threat)
        db_session.commit()
        
        # التحقق
        saved_threat = db_session.query(Threat).filter_by(
            file_hash="test123"
        ).first()
        
        assert len(saved_threat.iocs) == 2
        assert any(ioc.ioc_value == "evil.com" for ioc in saved_threat.iocs)
    
    def test_concurrent_writes(self, db_engine):
        """اختبار الكتابة المتزامنة"""
        import threading
        
        def write_threats(thread_id):
            Session = sessionmaker(bind=db_engine)
            session = Session()
            
            for i in range(100):
                threat = Threat(
                    file_hash=f"thread_{thread_id}_hash_{i}",
                    threat_type="malware"
                )
                session.add(threat)
            
            session.commit()
            session.close()
        
        # تشغيل 10 threads
        threads = [
            threading.Thread(target=write_threats, args=(i,))
            for i in range(10)
        ]
        
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        
        # التحقق
        Session = sessionmaker(bind=db_engine)
        session = Session()
        count = session.query(Threat).count()
        session.close()
        
        assert count == 1000
```

### API Integration Tests

```python
# tests/integration/test_api_flow.py

import pytest
import asyncio
from httpx import AsyncClient
from cyberguard.main import app

@pytest.mark.asyncio
class TestThreatDetectionFlow:
    
    async def test_complete_scan_workflow(self):
        """اختبار سير العمل الكامل للفحص"""
        async with AsyncClient(app=app, base_url="http://test") as client:
            
            # 1. Upload file
            with open("tests/fixtures/malware.exe", "rb") as f:
                response = await client.post(
                    "/api/v2/threats/scan",
                    files={"file": f},
                    headers={"Authorization": "Bearer test_token"}
                )
            
            assert response.status_code == 200
            scan_id = response.json()["scan_id"]
            
            # 2. Poll for results
            for _ in range(30):  # max 30 seconds
                response = await client.get(
                    f"/api/v2/threats/scan/{scan_id}",
                    headers={"Authorization": "Bearer test_token"}
                )
                
                if response.json()["status"] == "completed":
                    break
                
                await asyncio.sleep(1)
            
            result = response.json()
            
            # 3. Verify results
            assert result["status"] == "completed"
            assert "threat_level" in result
            assert "detection" in result
            
            # 4. Create incident if critical
            if result["threat_level"] == "critical":
                incident_response = await client.post(
                    "/api/v2/incidents",
                    json={
                        "title": "Critical Malware Detected",
                        "severity": "critical",
                        "scan_id": scan_id
                    },
                    headers={"Authorization": "Bearer test_token"}
                )
                
                assert incident_response.status_code == 201
    
    async def test_rate_limiting(self):
        """اختبار Rate Limiting"""
        async with AsyncClient(app=app, base_url="http://test") as client:
            
            # إرسال 150 طلب (الحد 100/دقيقة)
            responses = []
            for _ in range(150):
                response = await client.get(
                    "/api/v2/health",
                    headers={"Authorization": "Bearer test_token"}
                )
                responses.append(response.status_code)
            
            # يجب أن يكون بعضها 429 (Too Many Requests)
            assert 429 in responses
            assert responses.count(429) >= 50
```

---

## 🤖 AI Model Tests

### Model Performance Tests

```python
# tests/ml/test_model_performance.py

import pytest
import torch
from cyberguard.ml.models import MalwareTransformer
from sklearn.metrics import (
    accuracy_score, 
    precision_score, 
    recall_score, 
    f1_score,
    roc_auc_score
)

class TestModelPerformance:
    
    @pytest.fixture
    def model(self):
        return MalwareTransformer.load("models/production/transformer_v8.pth")
    
    @pytest.fixture
    def test_data(self):
        from cyberguard.data import load_test_dataset
        return load_test_dataset(split='test', samples=10000)
    
    def test_accuracy_threshold(self, model, test_data):
        """اختبار الدقة - يجب أن تكون > 99%"""
        X_test, y_test = test_data
        
        predictions = model.predict(X_test)
        accuracy = accuracy_score(y_test, predictions)
        
        assert accuracy > 0.99, f"Accuracy {accuracy:.4f} below 99%"
    
    def test_precision_recall(self, model, test_data):
        """اختبار Precision & Recall"""
        X_test, y_test = test_data
        
        predictions = model.predict(X_test)
        
        precision = precision_score(y_test, predictions)
        recall = recall_score(y_test, predictions)
        f1 = f1_score(y_test, predictions)
        
        # المتطلبات
        assert precision > 0.98, f"Precision {precision:.4f} too low"
        assert recall > 0.99, f"Recall {recall:.4f} too low"
        assert f1 > 0.98, f"F1 {f1:.4f} too low"
    
    def test_false_positive_rate(self, model, test_data):
        """اختبار معدل False Positives - يجب أن يكون < 1%"""
        X_test, y_test = test_data
        
        predictions = model.predict(X_test)
        
        # حساب FP
        false_positives = ((predictions == 1) & (y_test == 0)).sum()
        total_negatives = (y_test == 0).sum()
        fpr = false_positives / total_negatives
        
        assert fpr < 0.01, f"FPR {fpr:.4f} exceeds 1%"
    
    def test_inference_latency(self, model, benchmark):
        """اختبار سرعة الاستدلال - يجب أن يكون < 50ms"""
        sample = torch.randn(1, model.input_size)
        
        result = benchmark(model.predict, sample)
        
        # benchmark يوفر إحصائيات الأداء
        assert result is not None
    
    def test_adversarial_robustness(self, model, test_data):
        """اختبار المقاومة ضد Adversarial Examples"""
        from cyberguard.ml.adversarial import generate_fgsm_attack
        
        X_test, y_test = test_data[:100]  # عينة صغيرة
        
        # توليد adversarial examples
        X_adv = generate_fgsm_attack(model, X_test, epsilon=0.1)
        
        # التنبؤ
        predictions_clean = model.predict(X_test)
        predictions_adv = model.predict(X_adv)
        
        # حساب Robustness
        accuracy_drop = (
            accuracy_score(y_test, predictions_clean) -
            accuracy_score(y_test, predictions_adv)
        )
        
        # يجب ألا يتجاوز الانخفاض 10%
        assert accuracy_drop < 0.10, f"Accuracy drop {accuracy_drop:.4f} too high"
    
    def test_model_bias(self, model):
        """اختبار التحيز في النموذج"""
        from cyberguard.ml.fairness import check_bias
        
        # تحميل datasets متنوعة
        datasets = {
            'windows': load_windows_malware(),
            'linux': load_linux_malware(),
            'android': load_android_malware()
        }
        
        accuracies = {}
        for platform, (X, y) in datasets.items():
            preds = model.predict(X)
            accuracies[platform] = accuracy_score(y, preds)
        
        # التحقق من عدم وجود تحيز كبير
        max_diff = max(accuracies.values()) - min(accuracies.values())
        assert max_diff < 0.05, f"Bias detected: {accuracies}"
    
    @pytest.mark.slow
    def test_model_drift(self, model):
        """اختبار انحراف النموذج مع الوقت"""
        from cyberguard.ml.monitoring import detect_drift
        
        # بيانات إنتاج حديثة
        recent_data = load_production_data(days=7)
        
        # الكشف عن الانحراف
        drift_score = detect_drift(model, recent_data)
        
        # يجب أن يكون الانحراف منخفضاً
        assert drift_score < 0.15, f"Model drift detected: {drift_score}"
```

### Model Unit Tests

```python
# tests/ml/test_model_components.py

def test_feature_extraction():
    """اختبار استخراج الخصائص"""
    from cyberguard.ml.features import FeatureExtractor
    
    extractor = FeatureExtractor()
    
    # ملف اختبار
    sample_file = "tests/fixtures/sample.exe"
    features = extractor.extract(sample_file)
    
    assert features is not None
    assert len(features) == extractor.feature_count
    assert all(isinstance(f, (int, float)) for f in features)

def test_model_serialization():
    """اختبار حفظ وتحميل النموذج"""
    from cyberguard.ml.models import MalwareTransformer
    import tempfile
    
    # إنشاء نموذج
    model = MalwareTransformer(input_size=1024, hidden_size=256)
    
    # حفظ
    with tempfile.NamedTemporaryFile(suffix='.pth') as f:
        model.save(f.name)
        
        # تحميل
        loaded_model = MalwareTransformer.load(f.name)
        
        # التحقق
        assert loaded_model.input_size == model.input_size
        assert loaded_model.hidden_size == model.hidden_size
```

---

## 🔐 Security Tests

### Vulnerability Scanning

```bash
#!/bin/bash
# tests/security/scan.sh

echo "🔍 Running Security Scans..."

# 1. Dependency vulnerabilities
echo "Checking dependencies..."
safety check --json
pip-audit

# 2. Container scanning
echo "Scanning Docker images..."
trivy image cyberguard/api:latest \
  --severity CRITICAL,HIGH \
  --exit-code 1

# 3. Secret scanning
echo "Scanning for secrets..."
trufflehog filesystem . \
  --json \
  --fail

# 4. SAST (Static Application Security Testing)
echo "Running SAST..."
bandit -r cyberguard/ -f json -o bandit-report.json
semgrep --config=auto cyberguard/

# 5. License compliance
echo "Checking licenses..."
pip-licenses --fail-on="GPL"

echo "✅ Security scans complete!"
```

### Penetration Testing

```python
# tests/security/test_penetration.py

import pytest
from cyberguard_client import CyberGuardClient

class TestPenetrationTesting:
    
    @pytest.fixture
    def client(self):
        return CyberGuardClient(
            base_url="https://staging.cyberguard-ai.io",
            api_key="test_key"
        )
    
    def test_sql_injection(self, client):
        """اختبار SQL Injection"""
        malicious_inputs = [
            "' OR '1'='1",
            "admin'--",
            "1' UNION SELECT NULL--"
        ]
        
        for payload in malicious_inputs:
            response = client.search_threats(query=payload)
            
            # يجب أن يرفض الطلب أو يُعقم المدخلات
            assert response.status_code in [400, 422]
            assert "error" in response.json()
    
    def test_xss_protection(self, client):
        """اختبار XSS Protection"""
        xss_payloads = [
            "<script>alert('XSS')</script>",
            "<img src=x onerror=alert('XSS')>",
            "javascript:alert('XSS')"
        ]
        
        for payload in xss_payloads:
            response = client.create_incident(
                title=payload,
                description="Test"
            )
            
            # التحقق من تعقيم المدخلات
            if response.status_code == 201:
                incident = response.json()
                assert "<script>" not in incident['title']
                assert "javascript:" not in incident['title']
    
    def test_authentication_bypass(self, client):
        """اختبار تجاوز المصادقة"""
        # محاولة الوصول بدون token
        client.api_key = None
        response = client.get_threats()
        
        assert response.status_code == 401
    
    def test_rate_limit_bypass(self, client):
        """اختبار تجاوز Rate Limiting"""
        # محاولة إرسال طلبات كثيرة
        responses = []
        for _ in range(200):
            response = client.health_check()
            responses.append(response.status_code)
        
        # يجب أن يتم حظر بعض الطلبات
        assert 429 in responses  # Too Many Requests
```

---

## ⚡ Performance Tests

### Load Testing (k6)

```javascript
// tests/performance/load-test.js

import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const errorRate = new Rate('errors');

export const options = {
  stages: [
    { duration: '2m', target: 100 },   // Ramp up
    { duration: '5m', target: 100 },   // Stay at 100 users
    { duration: '2m', target: 200 },   // Ramp to 200
    { duration: '5m', target: 200 },   // Stay at 200
    { duration: '2m', target: 0 },     // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% < 500ms
    errors: ['rate<0.01'],             // Error rate < 1%
  },
};

const BASE_URL = 'https://api.cyberguard-ai.io';
const API_KEY = __ENV.API_KEY;

export default function () {
  // 1. Health check
  let res = http.get(`${BASE_URL}/health`);
  check(res, {
    'health check status 200': (r) => r.status === 200,
  });

  sleep(1);

  // 2. Get threat intel
  res = http.get(
    `${BASE_URL}/v2/threats/intelligence?ioc=203.0.113.45`,
    {
      headers: { 'Authorization': `Bearer ${API_KEY}` },
    }
  );
  
  check(res, {
    'threat intel status 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  
  errorRate.add(res.status !== 200);

  sleep(2);
}

// Spike test
export function spike() {
  // Sudden traffic spike
  for (let i = 0; i < 1000; i++) {
    http.get(`${BASE_URL}/health`);
  }
}
```

### Stress Testing

```python
# tests/performance/stress_test.py

import locust
from locust import HttpUser, task, between

class CyberGuardUser(HttpUser):
    wait_time = between(1, 3)
    
    def on_start(self):
        """تسجيل الدخول"""
        self.client.headers.update({
            'Authorization': 'Bearer test_token'
        })
    
    @task(3)
    def health_check(self):
        """Health check - most common"""
        self.client.get("/health")
    
    @task(2)
    def get_threats(self):
        """Get threats"""
        self.client.get("/api/v2/threats")
    
    @task(1)
    def scan_file(self):
        """Scan file - expensive operation"""
        files = {'file': ('test.exe', b'\x00' * 1024)}
        self.client.post("/api/v2/threats/scan", files=files)

# Run: locust -f stress_test.py --host=https://api.cyberguard-ai.io
```

---

## 🎭 End-to-End Tests

### E2E with Playwright

```typescript
// tests/e2e/threat-detection.spec.ts

import { test, expect } from '@playwright/test';

test.describe('Threat Detection Flow', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('https://dashboard.cyberguard-ai.io');
    
    // Login
    await page.fill('[name="email"]', 'test@cyberguard.io');
    await page.fill('[name="password"]', 'testpass123');
    await page.click('button[type="submit"]');
    
    await expect(page).toHaveURL(/.*dashboard/);
  });
  
  test('should scan and detect malware', async ({ page }) => {
    // Navigate to scan page
    await page.click('text=Scan File');
    
    // Upload file
    const fileInput = await page.locator('input[type="file"]');
    await fileInput.setInputFiles('tests/fixtures/malware.exe');
    
    // Start scan
    await page.click('button:has-text("Start Scan")');
    
    // Wait for results
    await page.waitForSelector('.scan-complete', { timeout: 30000 });
    
    // Verify results
    const threatLevel = await page.textContent('.threat-level');
    expect(threatLevel).toContain('Critical');
    
    const malwareFamily = await page.textContent('.malware-family');
    expect(malwareFamily).toBeTruthy();
    
    // Check if alert was created
    await page.click('text=Alerts');
    await expect(page.locator('.alert-item').first()).toBeVisible();
  });
  
  test('should create and manage incident', async ({ page }) => {
    // Create incident
    await page.click('text=Incidents');
    await page.click('button:has-text("New Incident")');
    
    await page.fill('[name="title"]', 'Test Ransomware Attack');
    await page.selectOption('[name="severity"]', 'critical');
    await page.fill('[name="description"]', 'Test incident description');
    
    await page.click('button:has-text("Create")');
    
    // Verify creation
    await expect(page.locator('text=Test Ransomware Attack')).toBeVisible();
    
    // Update status
    await page.click('.incident-item:has-text("Test Ransomware Attack")');
    await page.selectOption('[name="status"]', 'investigating');
    await page.click('button:has-text("Update")');
    
    // Verify update
    const status = await page.textContent('.incident-status');
    expect(status).toContain('Investigating');
  });
});
```

---

## 📊 Test Coverage & Reporting

### Coverage Configuration

```ini
# .coveragerc

[run]
source = cyberguard
omit =
    */tests/*
    */migrations/*
    */__pycache__/*
    */venv/*

[report]
precision = 2
show_missing = True
skip_covered = False

exclude_lines =
    pragma: no cover
    def __repr__
    raise AssertionError
    raise NotImplementedError
    if __name__ == .__main__.:
    if TYPE_CHECKING:
```

### Test Execution Matrix

```yaml
# .github/workflows/test-matrix.yml

name: Test Matrix

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        python-version: ['3.11', '3.12']
        node-version: ['20', '22']
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}
      
      - name: Run Python tests
        run: |
          pip install -r requirements.txt
          pytest --cov --cov-report=xml
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

---

## ✅ Test Checklist

Before deploying to production:

- [ ] All unit tests pass (>90% coverage)
- [ ] Integration tests pass
- [ ] AI model accuracy > 99%
- [ ] Security scans clean (no CRITICAL/HIGH)
- [ ] Performance tests meet SLA
- [ ] E2E tests pass on staging
- [ ] Load test completed successfully
- [ ] Documentation updated

---

**Testing is not a phase, it's a mindset! 🧪🚀**
