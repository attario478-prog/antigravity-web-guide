import os
import json
import uuid
import subprocess
from pathlib import Path
from typing import Dict, Optional

from fastapi import FastAPI, WebSocket, HTTPException
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Antigravity Web API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

WORKSPACE_ROOT = Path(os.getenv("WORKSPACE_ROOT", "/tmp/antigravity-workspaces"))
WORKSPACE_ROOT.mkdir(parents=True, exist_ok=True)

SESSIONS: Dict[str, subprocess.Popen] = {}


@app.get("/health")
async def health() -> dict:
    return {"status": "ok"}


@app.post("/chat/start")
async def start_chat(prompt: str, model: str = "gemini-2.0-flash"):
    session_id = str(uuid.uuid4())
    workspace = WORKSPACE_ROOT / session_id
    workspace.mkdir(parents=True, exist_ok=True)

    command = [
        "/usr/bin/agy",
        "--input-format",
        "stream-json",
        "--output-format",
        "stream-json",
        "--print-timeout",
        "60m",
        "--dangerously-skip-permissions",
        "--model",
        model,
        "--new-project",
    ]

    proc = subprocess.Popen(
        command,
        cwd=str(workspace),
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1,
    )

    request = {
        "event": "user",
        "message": {
            "content": f"""
<pocketdev_workspace>
The active project workspace is {workspace}.
Create, edit, read, run, and build project files only inside this directory.
</pocketdev_workspace>

{prompt}
"""
        },
    }

    if proc.stdin:
        proc.stdin.write(json.dumps(request) + "\n")
        proc.stdin.flush()
        proc.stdin.close()

    SESSIONS[session_id] = proc
    return {"session_id": session_id, "status": "started"}


@app.websocket("/ws/chat/{session_id}")
async def ws_chat(websocket: WebSocket, session_id: str):
    await websocket.accept()
    proc = SESSIONS.get(session_id)
    if proc is None:
        await websocket.send_json({"event": "error", "message": "Session not found"})
        await websocket.close()
        return

    try:
        for line in proc.stdout:  # type: ignore[union-attr]
            if not line.strip():
                continue
            try:
                await websocket.send_json(json.loads(line))
            except Exception:
                pass
    finally:
        if proc.poll() is None:
            proc.terminate()
        SESSIONS.pop(session_id, None)
        await websocket.close()


@app.post("/chat/{session_id}/stop")
async def stop_chat(session_id: str):
    proc = SESSIONS.get(session_id)
    if proc is None:
        raise HTTPException(status_code=404, detail="Session not found")
    if proc.poll() is None:
        proc.terminate()
    SESSIONS.pop(session_id, None)
    return {"status": "stopped"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=int(os.getenv("PORT", "8080")))
