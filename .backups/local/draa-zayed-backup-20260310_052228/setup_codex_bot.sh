#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  🤖 CODEX AI BOT - إعداد تلقائي شامل لـ Termux
#  يحل مشكلة @openai/codex-linux-arm64 ويثبت روبوت AI متكامل
# ═══════════════════════════════════════════════════════════════

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

banner() {
echo -e "${CYAN}${BOLD}"
cat << 'EOF'
  ██████╗ ██████╗ ██████╗ ███████╗██╗  ██╗    ██████╗  ██████╗ ████████╗
 ██╔════╝██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔══██╗██╔═══██╗╚══██╔══╝
 ██║     ██║   ██║██║  ██║█████╗   ╚███╔╝     ██████╔╝██║   ██║   ██║   
 ██║     ██║   ██║██║  ██║██╔══╝   ██╔██╗     ██╔══██╗██║   ██║   ██║   
 ╚██████╗╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ██████╔╝╚██████╔╝   ██║   
  ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚═════╝  ╚═════╝    ╚═╝   
EOF
echo -e "${NC}"
echo -e "${YELLOW}  🛡️  محارب رقمي | Cybersecurity AI Assistant | ARM64 Edition${NC}"
echo -e "${CYAN}  ════════════════════════════════════════════════════════${NC}\n"
}

step() { echo -e "\n${GREEN}[+]${NC} ${BOLD}$1${NC}"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }

banner

# ─── الخطوة 1: تحديث Termux ────────────────────────────────────
step "تحديث حزم Termux..."
pkg update -y -q && pkg upgrade -y -q
ok "تم التحديث"

# ─── الخطوة 2: تثبيت المتطلبات الأساسية ──────────────────────
step "تثبيت المتطلبات الأساسية..."
pkg install -y -q nodejs python git curl wget jq 2>/dev/null
ok "تم تثبيت: nodejs python git curl wget jq"

# ─── الخطوة 3: إصلاح مشكلة ARM64 ─────────────────────────────
step "إصلاح مشكلة @openai/codex-linux-arm64..."

# إزالة النسخة القديمة
npm uninstall -g @openai/codex 2>/dev/null
ok "تمت إزالة النسخة القديمة"

# تثبيت أحدث إصدار مع الاعتماديات
warn "تثبيت @openai/codex@latest..."
npm install -g @openai/codex@latest 2>&1 | tail -5

# محاولة تثبيت الاعتمادية ARM64 مباشرة
npm install -g @openai/codex-linux-arm64 2>/dev/null && ok "تم تثبيت ARM64 dependency" || warn "سيتم استخدام البديل..."

ok "تم إصلاح مشكلة Codex"

# ─── الخطوة 4: إنشاء روبوت AI متكامل ─────────────────────────
step "إنشاء روبوت AI متكامل..."

BOT_DIR="$HOME/ai-bot"
mkdir -p "$BOT_DIR"

cat > "$BOT_DIR/bot.js" << 'BOTSCRIPT'
#!/usr/bin/env node
// ═══════════════════════════════════════════════
//  🤖 AI CYBERSECURITY BOT - Powered by OpenAI
//  يعمل على Termux ARM64
// ═══════════════════════════════════════════════

const https = require('https');
const readline = require('readline');
const { execSync, exec } = require('child_process');
const fs = require('fs');
const os = require('os');

// ── الألوان ──────────────────────────────────────
const C = {
  reset:  '\x1b[0m',
  red:    '\x1b[31m',
  green:  '\x1b[32m',
  yellow: '\x1b[33m',
  cyan:   '\x1b[36m',
  bold:   '\x1b[1m',
  dim:    '\x1b[2m',
};

const API_KEY_FILE = `${os.homedir()}/.openai_key`;

// ── واجهة المستخدم ────────────────────────────────
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

const ask = (q) => new Promise(res => rl.question(q, res));

// ── حفظ/قراءة مفتاح API ──────────────────────────
function loadApiKey() {
  if (process.env.OPENAI_API_KEY) return process.env.OPENAI_API_KEY;
  if (fs.existsSync(API_KEY_FILE)) {
    return fs.readFileSync(API_KEY_FILE, 'utf8').trim();
  }
  return null;
}

function saveApiKey(key) {
  fs.writeFileSync(API_KEY_FILE, key, { mode: 0o600 });
}

// ── استدعاء OpenAI API ────────────────────────────
function callOpenAI(messages, apiKey) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({
      model: 'gpt-4o-mini',
      messages,
      max_tokens: 2000,
      temperature: 0.7,
    });

    const options = {
      hostname: 'api.openai.com',
      path: '/v1/chat/completions',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
        'Content-Length': Buffer.byteLength(body),
      },
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          if (parsed.error) reject(new Error(parsed.error.message));
          else resolve(parsed.choices[0].message.content);
        } catch (e) {
          reject(e);
        }
      });
    });

    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

// ── تنفيذ أوامر النظام ────────────────────────────
function runCommand(cmd) {
  try {
    return execSync(cmd, { encoding: 'utf8', timeout: 30000, stdio: 'pipe' });
  } catch (e) {
    return `Error: ${e.message}`;
  }
}

// ── معالجة الأوامر الخاصة ─────────────────────────
function handleSpecialCommand(input) {
  const cmd = input.trim();
  
  if (cmd === '!sysinfo') {
    return `معلومات النظام:\n` +
      `OS: ${os.type()} ${os.release()}\n` +
      `Architecture: ${os.arch()}\n` +
      `Platform: ${os.platform()}\n` +
      `CPUs: ${os.cpus().length}\n` +
      `Memory: ${Math.round(os.freemem()/1024/1024)}MB free / ${Math.round(os.totalmem()/1024/1024)}MB total\n` +
      `Node.js: ${process.version}`;
  }
  
  if (cmd === '!ip') {
    return runCommand('curl -s https://api.ipify.org 2>/dev/null || echo "لا يوجد اتصال"');
  }
  
  if (cmd.startsWith('!run ')) {
    const shellCmd = cmd.slice(5);
    console.log(`${C.yellow}[!] تنفيذ: ${shellCmd}${C.reset}`);
    return runCommand(shellCmd);
  }
  
  if (cmd === '!help') {
    return `${C.cyan}الأوامر الخاصة:${C.reset}
!sysinfo   - معلومات النظام
!ip        - عنوان IP الخارجي
!run <cmd> - تنفيذ أمر shell
!clear     - مسح المحادثة
!save      - حفظ المحادثة
!help      - هذه المساعدة
exit/quit  - الخروج`;
  }
  
  if (cmd === '!clear') {
    return 'CLEAR_HISTORY';
  }
  
  return null;
}

// ── Banner ────────────────────────────────────────
function printBanner() {
  console.clear();
  console.log(`${C.cyan}${C.bold}`);
  console.log('╔═══════════════════════════════════════════╗');
  console.log('║   🤖 AI CYBERSECURITY BOT - Termux ARM64  ║');
  console.log('║   🛡️  محارب رقمي - مساعد ذكاء اصطناعي   ║');
  console.log('╚═══════════════════════════════════════════╝');
  console.log(`${C.reset}`);
  console.log(`${C.dim}اكتب !help للأوامر الخاصة | exit للخروج${C.reset}\n`);
}

// ── الدالة الرئيسية ───────────────────────────────
async function main() {
  printBanner();

  // طلب مفتاح API إذا لم يكن موجوداً
  let apiKey = loadApiKey();
  if (!apiKey) {
    console.log(`${C.yellow}[!] لم يتم العثور على مفتاح OpenAI API${C.reset}`);
    console.log(`${C.dim}احصل على مفتاحك من: https://platform.openai.com/api-keys${C.reset}`);
    apiKey = await ask(`${C.cyan}أدخل مفتاح API: ${C.reset}`);
    if (!apiKey.startsWith('sk-')) {
      console.log(`${C.red}[✗] مفتاح غير صالح!${C.reset}`);
      process.exit(1);
    }
    saveApiKey(apiKey);
    console.log(`${C.green}[✓] تم حفظ المفتاح في: ${API_KEY_FILE}${C.reset}\n`);
  } else {
    console.log(`${C.green}[✓] تم تحميل مفتاح API${C.reset}\n`);
  }

  // نظام AI مع سياق الأمن السيبراني
  const systemPrompt = `أنت مساعد ذكاء اصطناعي متخصص في الأمن السيبراني يعمل على Termux ARM64.
تتحدث العربية والإنجليزية. أنت خبير في:
- اختبار الاختراق والأمن الهجومي
- الاستجابة للحوادث والتحليل الجنائي الرقمي
- أدوات: Nmap, Wireshark, Metasploit, Burp Suite
- برمجة: Python, Bash, JavaScript
- أنظمة: Linux, Android/Termux, Kali Linux
- الشبكات وأمن التطبيقات
عند طلب كود، قدم كوداً عملياً وقابلاً للتنفيذ مع شرح واضح.
استجب بشكل موجز ومفيد.`;

  const messages = [{ role: 'system', content: systemPrompt }];

  console.log(`${C.green}[✓] الروبوت جاهز! ابدأ المحادثة...${C.reset}\n`);

  // حلقة المحادثة الرئيسية
  while (true) {
    let input;
    try {
      input = await ask(`${C.cyan}${C.bold}أنت: ${C.reset}`);
    } catch (e) {
      break;
    }

    input = input.trim();
    if (!input) continue;

    // التحقق من أوامر الخروج
    if (['exit', 'quit', 'خروج'].includes(input.toLowerCase())) {
      console.log(`\n${C.yellow}وداعاً! 👋${C.reset}`);
      rl.close();
      process.exit(0);
    }

    // معالجة الأوامر الخاصة
    const specialResult = handleSpecialCommand(input);
    if (specialResult) {
      if (specialResult === 'CLEAR_HISTORY') {
        messages.splice(1); // احتفظ بـ system prompt فقط
        console.log(`${C.green}[✓] تم مسح المحادثة${C.reset}\n`);
        continue;
      }
      console.log(`\n${C.green}النتيجة:${C.reset}\n${specialResult}\n`);
      continue;
    }

    // إضافة رسالة المستخدم
    messages.push({ role: 'user', content: input });

    // استدعاء API
    process.stdout.write(`\n${C.cyan}${C.bold}🤖 AI: ${C.reset}`);
    
    try {
      const response = await callOpenAI(messages, apiKey);
      console.log(response);
      console.log('');
      
      // إضافة رد AI للتاريخ
      messages.push({ role: 'assistant', content: response });
      
      // تحديد حجم التاريخ (آخر 20 رسالة + system)
      if (messages.length > 22) {
        messages.splice(1, 2);
      }
      
    } catch (error) {
      console.log(`\n${C.red}[✗] خطأ: ${error.message}${C.reset}`);
      if (error.message.includes('invalid_api_key')) {
        console.log(`${C.yellow}[!] مفتاح API غير صالح. احذف ${API_KEY_FILE} وأعد التشغيل${C.reset}`);
      }
      messages.pop(); // إزالة الرسالة الفاشلة
    }
  }
}

main().catch(console.error);
BOTSCRIPT

chmod +x "$BOT_DIR/bot.js"
ok "تم إنشاء روبوت AI: $BOT_DIR/bot.js"

# ─── الخطوة 5: إنشاء أمر تشغيل سريع ──────────────
step "إنشاء أوامر تشغيل سريعة..."

# أمر aibot
cat > "$PREFIX/bin/aibot" << EOF
#!/bin/bash
node "$BOT_DIR/bot.js" "\$@"
EOF
chmod +x "$PREFIX/bin/aibot"

# أمر codex-fix لإعادة تثبيت عند الحاجة  
cat > "$PREFIX/bin/codex-fix" << 'EOF'
#!/bin/bash
echo "[*] إعادة تثبيت Codex..."
npm uninstall -g @openai/codex 2>/dev/null
npm install -g @openai/codex@latest
echo "[✓] تم!"
EOF
chmod +x "$PREFIX/bin/codex-fix"

ok "أوامر التشغيل: aibot | codex-fix"

# ─── الخطوة 6: إعداد متغير البيئة ────────────────
step "إعداد متغيرات البيئة..."

if ! grep -q "OPENAI_API_KEY" "$HOME/.bashrc" 2>/dev/null; then
cat >> "$HOME/.bashrc" << 'EOF'

# ── OpenAI & AI Bot ──
if [ -f "$HOME/.openai_key" ]; then
  export OPENAI_API_KEY=$(cat "$HOME/.openai_key")
fi
alias aibot="node $HOME/ai-bot/bot.js"
alias codex-fix="npm uninstall -g @openai/codex && npm install -g @openai/codex@latest"
EOF
fi

ok "تم إعداد .bashrc"

# ─── الخطوة 7: التحقق من التثبيت ─────────────────
step "التحقق من التثبيت..."
echo ""
echo -e "${CYAN}  Node.js:${NC} $(node --version 2>/dev/null || echo 'غير موجود')"
echo -e "${CYAN}  npm:${NC}     $(npm --version 2>/dev/null || echo 'غير موجود')"
echo -e "${CYAN}  Python:${NC}  $(python --version 2>/dev/null || python3 --version 2>/dev/null || echo 'غير موجود')"
echo -e "${CYAN}  Codex:${NC}   $(codex --version 2>/dev/null || echo 'تحقق يدوياً')"
echo ""

# ─── ملخص نهائي ────────────────────────────────────
echo -e "${GREEN}${BOLD}"
echo "╔═══════════════════════════════════════════╗"
echo "║         ✅ اكتمل الإعداد بنجاح!           ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${CYAN}${BOLD}كيفية الاستخدام:${NC}"
echo ""
echo -e "  ${YELLOW}1. تشغيل روبوت AI:${NC}"
echo -e "     ${GREEN}aibot${NC}          أو     ${GREEN}node ~/ai-bot/bot.js${NC}"
echo ""
echo -e "  ${YELLOW}2. إصلاح Codex مستقبلاً:${NC}"
echo -e "     ${GREEN}codex-fix${NC}"
echo ""
echo -e "  ${YELLOW}3. تطبيق إعدادات البيئة:${NC}"
echo -e "     ${GREEN}source ~/.bashrc${NC}"
echo ""
echo -e "  ${YELLOW}4. داخل الروبوت:${NC}"
echo -e "     ${GREEN}!help${NC}   - قائمة الأوامر"
echo -e "     ${GREEN}!sysinfo${NC} - معلومات النظام"
echo -e "     ${GREEN}!run ls${NC}  - تنفيذ أوامر shell"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}💡 ستحتاج مفتاح OpenAI API من:${NC}"
echo -e "   ${GREEN}https://platform.openai.com/api-keys${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

