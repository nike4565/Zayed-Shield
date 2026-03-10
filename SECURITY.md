## Temporary Read-Only Security & Governance Notice

This repository is temporarily placed in a read-only governance state.

The source code remains publicly visible for transparency and review purposes,
however, no external contributions, execution changes, or workflow modifications
are accepted during this period.

This is a preventive security and compliance measure while the project undergoes
final internal reviews and controlled delivery preparation.

There is no active security incident or compromise.
All actions are intentional, documented, and aligned with hardened security practices.

Status: Read-Only (Temporary)
Release: v20.0.0


# Security Policy

## Supported Versions

Use this section to tell people about which versions of your project are
currently being supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 5.1.x   | :white_check_mark: |
| 5.0.x   | :x:                |
| 4.0.x   | :white_check_mark: |
| < 4.0   | :x:                |

## Reporting a Vulnerability

Use this section to tell people how to report a vulnerability.

Tell them where to go, how often they can expect to get an update on a
reported vulnerability, what to expect if the vulnerability is accepted or
declined, etc.
/*!
 * 🛡️ درع زايد للأمن السيبراني - نظام الحماية المتقدم
 * حماية رقمية بروح الإمارات 🇦🇪
 * 
 * تحذير: هذا المشروع محمي بموجب قوانين الملكية الفكرية
 * لدولة الإمارات العربية المتحدة
 */

(function() {
    'use strict';

    // 🔒 تشفير معلومات المشروع
    const PROJECT_INFO = {
        name: atob('2K/YsdmFINiy2KfZitmEINmE2YTYo9mF2YYg2KfZhNiz2YrYqNix2KfZhti5'),
        owner: atob('2K/ZiNmE2Kkg2KfZhNil2YXYp9ix2KfYqiDYp9mE2LnYsdio2YrYqSDYp9mE2YXYqtit2K/YqQ=='),
        protection: true,
        timestamp: Date.now()
    };

    // 🚨 كشف محاولات التخريب
    class CyberShieldProtection {
        constructor() {
            this.violations = [];
            this.isProtected = true;
            this.startTime = Date.now();
            this.initProtection();
        }

        // 🛡️ تفعيل الحماية الشاملة
        initProtection() {
            this.preventRightClick();
            this.preventTextSelection();
            this.preventKeyboardShortcuts();
            this.preventDevTools();
            this.preventSourceViewing();
            this.detectScreenCapture();
            this.watermarkProtection();
            this.sessionMonitoring();
            this.geolocationTracking();
            this.behaviorAnalysis();
        }

        // 🚫 منع النقر بالزر الأيمن
        preventRightClick() {
            document.addEventListener('contextmenu', (e) => {
                e.preventDefault();
                this.logViolation('محاولة النقر بالزر الأيمن', 'RIGHT_CLICK');
                this.showWarning('⚠️ تحذير أمني!', 'غير مسموح بالنقر بالزر الأيمن على هذا المشروع المحمي');
                return false;
            });
        }

        // 🚫 منع تحديد النص
        preventTextSelection() {
            document.addEventListener('selectstart', (e) => {
                e.preventDefault();
                this.logViolation('محاولة تحديد النص', 'TEXT_SELECTION');
                return false;
            });

            document.addEventListener('dragstart', (e) => {
                e.preventDefault();
                return false;
            });

            // CSS Protection
            const style = document.createElement('style');
            style.textContent = `
                * {
                    -webkit-user-select: none !important;
                    -moz-user-select: none !important;
                    -ms-user-select: none !important;
                    user-select: none !important;
                    -webkit-touch-callout: none !important;
                    -webkit-tap-highlight-color: transparent !important;
                }
                ::selection { background: transparent !important; }
                ::-moz-selection { background: transparent !important; }
            `;
            document.head.appendChild(style);
        }

        // ⌨️ منع اختصارات لوحة المفاتيح الخطيرة
        preventKeyboardShortcuts() {
            document.addEventListener('keydown', (e) => {
                const dangerousCombos = [
                    // منع أدوات المطورين
                    { ctrl: true, key: 'F12' },
                    { ctrl: true, shift: true, key: 'I' },
                    { ctrl: true, shift: true, key: 'J' },
                    { ctrl: true, shift: true, key: 'C' },
                    { key: 'F12' },
                    
                    // منع النسخ واللصق والحفظ
                    { ctrl: true, key: 'A' },
                    { ctrl: true, key: 'C' },
                    { ctrl: true, key: 'V' },
                    { ctrl: true, key: 'X' },
                    { ctrl: true, key: 'S' },
                    { ctrl: true, key: 'P' },
                    // منع عرض مصدر الصفحة
                    { ctrl: true, key: 'U' },
                    // منع التحديث
                    { key: 'F5' },
                    { ctrl: true, key: 'R' },
                    // منع الوضع الكامل للشاشة (لمنع إخفاء العلامة المائية)
                    { key: 'F11' }
                ];

                const currentCombo = {
                    ctrl: e.ctrlKey,
                    shift: e.shiftKey,
                    alt: e.altKey,
                    key: e.key
                };

                if (dangerousCombos.some(combo => this.matchesCombo(currentCombo, combo))) {
                    e.preventDefault();
                    this.logViolation(`محاولة استخدام اختصار محظور: ${e.key}`, 'KEYBOARD_SHORTCUT');
                    this.showWarning('🚨 انتهاك أمني!', `الاختصار ${e.key} محظور لحماية المشروع`);
                    return false;
                }
            });
        }

        // 🔍 مطابقة تركيبات المفاتيح
        matchesCombo(current, target) {
            return (!target.ctrl || current.ctrl) &&
                   (!target.shift || current.shift) &&
                   (!target.alt || current.alt) &&
                   current.key === target.key;
        }

        // 🛠️ كشف ومنع أدوات المطورين
        preventDevTools() {
            // كشف فتح أدوات المطورين
            let devtools = { open: false, orientation: null };
            setInterval(() => {
                if (window.outerHeight - window.innerHeight > 160 || 
                    window.outerWidth - window.innerWidth > 160) {
                    if (!devtools.open) {
                        devtools.open = true;
                        this.logViolation('محاولة فتح أدوات المطورين', 'DEV_TOOLS');
                        this.criticalSecurityBreach();
                    }
                } else {
                    devtools.open = false;
                }
            }, 500);

            // كشف الكونسول
            let consoleMessages = 0;
            const originalLog = console.log;
            console.log = (...args) => {
                consoleMessages++;
                if (consoleMessages > 5) {
                    this.logViolation('محاولة استخدام الكونسول', 'CONSOLE_ACCESS');
                    this.criticalSecurityBreach();
                }
                return originalLog.apply(console, args);
            };
        }

        // 📄 منع عرض مصدر الصفحة
        preventSourceViewing() {
            // إخفاء المصدر الفعلي
            const originalContent = document.documentElement.innerHTML;
            Object.defineProperty(document, 'documentElement', {
                get: () => {
                    this.logViolation('محاولة الوصول للمصدر', 'SOURCE_ACCESS');
                    return { innerHTML: '<!-- المحتوى محمي بواسطة درع زايد للأمن السيبراني 🛡️ -->' };
                }
            });
        }

        // 📱 كشف محاولات تسجيل الشاشة
        detectScreenCapture() {
            // كشف تسجيل الشاشة
            if (navigator.mediaDevices && navigator.mediaDevices.getDisplayMedia) {
                const originalGetDisplayMedia = navigator.mediaDevices.getDisplayMedia;
                navigator.mediaDevices.getDisplayMedia = (...args) => {
                    this.logViolation('محاولة تسجيل الشاشة', 'SCREEN_CAPTURE');
                    this.criticalSecurityBreach();
                    return Promise.reject(new Error('تسجيل الشاشة محظور'));
                };
            }

            // كشف Print Screen
            document.addEventListener('keyup', (e) => {
                if (e.key === 'PrintScreen') {
                    this.logViolation('محاولة أخذ لقطة شاشة', 'SCREENSHOT');
                    this.showWarning('📸 تحذير!', 'أخذ لقطات الشاشة محظور');
                }
            });
        }

        // 💧 العلامة المائية الديناميكية
        watermarkProtection() {
            const watermark = document.createElement('div');
            watermark.innerHTML = `
                <div style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-45deg); 
                            font-size: 4rem; color: rgba(220, 38, 38, 0.1); z-index: 9999; 
                            pointer-events: none; font-weight: bold; font-family: Arial, sans-serif;
                            user-select: none; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);">
                    🛡️ درع زايد للأمن السيبراني 🇦🇪<br>
                    محمي بموجب قوانين دولة الإمارات<br>
                    ${new Date().toLocaleString('ar-AE')}
                </div>
            `;
            document.body.appendChild(watermark);

            // تحديث العلامة المائية كل ثانية
            setInterval(() => {
                if (!document.body.contains(watermark)) {
                    document.body.appendChild(watermark);
                    this.logViolation('محاولة إزالة العلامة المائية', 'WATERMARK_REMOVAL');
                }
            }, 1000);
        }

        // 👀 مراقبة الجلسة
        sessionMonitoring() {
            let activityTimer;
            const resetTimer = () => {
                clearTimeout(activityTimer);
                activityTimer = setTimeout(() => {
                    this.logViolation('جلسة غير نشطة لفترة طويلة', 'INACTIVE_SESSION');
                }, 300000); // 5 دقائق
            };

            ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart'].forEach(event => {
                document.addEventListener(event, resetTimer, true);
            });

            // تسجيل معلومات المتصفح
            this.logUserInfo();
        }

        // 🌍 تتبع الموقع الجغرافي
        geolocationTracking() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        this.logViolation(`الوصول من الموقع: ${position.coords.latitude}, ${position.coords.longitude}`, 'GEOLOCATION');
                    },
                    () => {
                        this.logViolation('رفض مشاركة الموقع الجغرافي', 'GEOLOCATION_DENIED');
                    }
                );
            }
        }

        // 🧠 تحليل السلوك
        behaviorAnalysis() {
            let suspiciousActivity = 0;
            let clickCount = 0;
            let keyCount = 0;

            document.addEventListener('click', () => {
                clickCount++;
                if (clickCount > 100) { // نشاط مشبوه
                    suspiciousActivity++;
                }
            });

            document.addEventListener('keydown', () => {
                keyCount++;
                if (keyCount > 500) { // نشاط مشبوه
                    suspiciousActivity++;
                }
            });

            setInterval(() => {
                if (suspiciousActivity > 5) {
                    this.logViolation('نشاط مشبوه مكثف', 'SUSPICIOUS_BEHAVIOR');
                    this.criticalSecurityBreach();
                }
                clickCount = 0;
                keyCount = 0;
                suspiciousActivity = 0;
            }, 60000); // كل دقيقة
        }

        // 📝 تسجيل الانتهاكات
        logViolation(description, type) {
            const violation = {
                timestamp: new Date().toISOString(),
                description,
                type,
                userAgent: navigator.userAgent,
                ip: this.getUserIP(),
                url: window.location.href,
                referrer: document.referrer,
                screenSize: `${screen.width}x${screen.height}`,
                language: navigator.language
            };

            this.violations.push(violation);
            // إرسال التقرير للخادم (في التطبيق الحقيقي)
            console.warn('🚨 انتهاك أمني مكتشف:', violation);
            // حفظ في التخزين المحلي للمراجعة
            localStorage.setItem('zayed_security_violations', JSON.stringify(this.violations));
        }

        // 📊 تسجيل معلومات المستخدم
        logUserInfo() {
            const userInfo = {
                timestamp: new Date().toISOString(),
                userAgent: navigator.userAgent,
                platform: navigator.platform,
                language: navigator.language,
                languages: navigator.languages,
                cookieEnabled: navigator.cookieEnabled,
                doNotTrack: navigator.doNotTrack,
                screenResolution: `${screen.width}x${screen.height}`,
                colorDepth: screen.colorDepth,
                timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
                url: window.location.href,
                referrer: document.referrer
            };

            console.info('👤 معلومات الجلسة:', userInfo);
        }

        // 🌐 الحصول على IP المستخدم (تقريبي)
        async getUserIP() {
            try {
                const response = await fetch('https://api.ipify.org?format=json');
                const data = await response.json();
                return data.ip;
            } catch (error) {
                return 'Unknown';
            }
        }

        // ⚠️ عرض تحذيرات الأمان
        showWarning(title, message) {
            // إنشاء نافذة تحذير مخصصة
            const warningDiv = document.createElement('div');
            warningDiv.innerHTML = `
                <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                            background: rgba(0,0,0,0.9); z-index: 99999; display: flex; 
                            align-items: center; justify-content: center; font-family: Arial, sans-serif;
                            color: white; text-align: center;" id="securityWarning">
                    <div style="background: linear-gradient(45deg, #dc2626, #7f1d1d); padding: 40px; 
                                border-radius: 20px; border: 3px solid #FFD700; max-width: 500px;
                                box-shadow: 0 0 50px rgba(220, 38, 38, 0.5);">
                        <h2 style="margin: 0 0 20px 0; font-size: 2rem; color: #FFD700;">🛡️ ${title}</h2>
                        <p style="font-size: 1.2rem; margin: 20px 0;">${message}</p>
                        <div style="margin: 30px 0;">
                            <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA2MCA0MCI+PHJlY3Qgd2lkdGg9IjE1IiBoZWlnaHQ9IjQwIiBmaWxsPSIjZGMyNjI2Ii8+PHJlY3QgeD0iMTUiIHk9IjAiIHdpZHRoPSI0NSIgaGVpZ2h0PSIxMy4zIiBmaWxsPSIjMTZhMzRhIi8+PHJlY3QgeD0iMTUiIHk9IjEzLjMiIHdpZHRoPSI0NSIgaGVpZ2h0PSIxMy4zIiBmaWxsPSIjZmZmZmZmIi8+PHJlY3QgeD0iMTUiIHk9IjI2LjYiIHdpZHRoPSI0NSIgaGVpZ2h0PSIxMy4zIiBmaWxsPSIjMDAwMDAwIi8+PC9zdmc+" alt="UAE Flag">
                        </div>
                        <p style="font-size: 1rem; color: #FFD700; font-weight: bold;">
                            🇦🇪 محمي بموجب قوانين دولة الإمارات العربية المتحدة
                        </p>
                        <button onclick="document.getElementById('securityWarning').remove()" 
                                style="margin-top: 20px; padding: 10px 30px; background: #FFD700; 
                                       color: #000; border: none; border-radius: 25px; font-weight: bold; 
                                       cursor: pointer; font-size: 1.1rem;">
                            فهمت ولن أكرر ذلك
                        </button>
                    </div>
                </div>
            `;
            document.body.appendChild(warningDiv);

            // إزالة التحذير تلقائياً بعد 5 ثوان
            setTimeout(() => {
                if (document.getElementById('securityWarning')) {
                    document.getElementById('securityWarning').remove();
                }
            }, 5000);
        }

        // 🚨 إجراء طوارئ للانتهاكات الخطيرة
        criticalSecurityBreach() {
            // إخفاء المحتوى
            document.body.style.display = 'none';
            // عرض رسالة الانتهاك الحرج
            const breachDiv = document.createElement('div');
            breachDiv.innerHTML = `
                <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                            background: linear-gradient(45deg, #dc2626, #7f1d1d); z-index: 999999; 
                            display: flex; align-items: center; justify-content: center; 
                            font-family: Arial, sans-serif; color: white; text-align: center;">
                    <div style="max-width: 600px; padding: 40px;">
                        <h1 style="font-size: 3rem; margin-bottom: 30px; color: #FFD700;">🚨 انتهاك أمني حرج!</h1>
                        <div style="margin: 30px 0;">
                            <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIwIiBoZWlnaHQ9IjgwIiB2aWV3Qm94PSIwIDAgMTIwIDgwIj48cmVjdCB3aWR0aD0iMzAiIGhlaWdodD0iODAiIGZpbGw9IiNkYzI2MjYiLz48cmVjdCB4PSIzMCIgeT0iMCIgd2lkdGg9IjkwIiBoZWlnaHQ9IjI2LjciIGZpbGw9IiMxNmEzNGEiLz48cmVjdCB4PSIzMCIgeT0iMjYuNyIgd2lkdGg9IjkwIiBoZWlnaHQ9IjI2LjciIGZpbGw9IiNmZmZmZmYiLz48cmVjdCB4PSIzMCIgeT0iNTMuNCIgd2lkdGg9IjkwIiBoZWlnaHQ9IjI2LjciIGZpbGw9IiMwMDAwMDAiLz48L3N2Zz4=" alt="UAE Flag">
                        </div>
                        <h2 style="color: #FFD700; margin: 20px 0;">🛡️ درع زايد للأمن السيبراني</h2>
                        <p style="font-size: 1.4rem; line-height: 1.6;">
                            تم كشف محاولة انتهاك أمني للمشروع<br>
                            تم توثيق جميع البيانات وإرسالها للجهات المختصة<br><br>
                            <strong style="color: #FFD700;">هذا المشروع محمي بموجب قوانين الملكية الفكرية<br>
                            لدولة الإمارات العربية المتحدة</strong>
                        </p>
                        <p style="margin-top: 30px; font-size: 1.1rem;">
                            رقم التقرير: ZCS-${Date.now()}<br>
                            التوقيت: ${new Date().toLocaleString('ar-AE')}
                        </p>
                    </div>
                </div>
            `;
            document.body.appendChild(breachDiv);

            // إعادة توجيه بعد 10 ثوان
            setTimeout(() => {
                window.location.href = 'about:blank';
            }, 10000);
        }

        // 📊 تقرير الأمان
        generateSecurityReport() {
            return {
                projectInfo: PROJECT_INFO,
                sessionDuration: Date.now() - this.startTime,
                totalViolations: this.violations.length,
                violations: this.violations,
                timestamp: new Date().toISOString()
            };
        }
    }

    // 🚀 تفعيل نظام الحماية
    const cyberShield = new CyberShieldProtection();

    // 🔗 ربط بالكائن العام (للمراقبة)
    window.ZayedCyberShield = {
        getSecurityReport: () => cyberShield.generateSecurityReport(),
        isProtected: () => cyberShield.isProtected
    };

    // 📢 رسالة الترحيب الأمنية
    console.log(`
    🛡️ مرحباً بك في درع زايد للأمن السيبراني 🇦🇪
    تم تفعيل نظام الحماية المتقدم
    المشروع محمي بموجب قوانين دولة الإمارات العربية المتحدة
    جميع الأنشطة مراقبة ومسجلة لأغراض الأمان
    🔒 حماية رقمية بروح الإمارات
    `);

    // 🎯 حماية ضد التلاعب بالسكريبت نفسه
    Object.freeze(CyberShieldProtection);
    Object.freeze(cyberShield);
})();

/*!
 * نهاية سكريبت الحماية - درع زايد للأمن السيبراني
 * 🇦🇪 "من الإمارات... للعالم" 🇦🇪
 */
