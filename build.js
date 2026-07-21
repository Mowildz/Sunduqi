const fs = require('fs');
const path = require('path');

const jsDir = path.join(__dirname, 'js');
if (!fs.existsSync(jsDir)) {
  fs.mkdirSync(jsDir, { recursive: true });
}

// Fallback to local hardcoded just in case, but on Vercel it will use env vars
const supabaseUrl = process.env.SUPABASE_URL || 'https://ympndvcjmwhvtttcthxv.supabase.co';
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || 'sb_publishable_BaiXJ3BQZX2VXON3rorFfQ_ASpo4m50';

const configContent = `
const SUPABASE_URL = "${supabaseUrl}";
const SUPABASE_ANON_KEY = "${supabaseAnonKey}";
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
`;

fs.writeFileSync(path.join(jsDir, 'config.js'), configContent.trim());
console.log('Build completed: js/config.js generated.');
