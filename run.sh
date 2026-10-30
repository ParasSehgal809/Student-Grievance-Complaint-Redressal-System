#!/bin/bash
# -------------------------------------------------------------
# Run Online Complaint Management System (AIP Mini Project)
# -------------------------------------------------------------
cd "$(dirname "$0")"

# Ensure Java and Maven paths are exported
export JAVA_HOME="$HOME/.vscode/extensions/redhat.java-1.58.0-darwin-arm64/jre/25.0.4.1-macosx-aarch64"
export PATH="$HOME/.local/bin:$JAVA_HOME/bin:$PATH"

if [ $# -gt 0 ]; then
  ./mvnw "$@"
else
  echo "============================================================"
  echo "  Online Complaint Management System (Java Servlet / JSP)"
  echo "  Server: http://localhost:8080/"
  echo "  Admin Login: http://localhost:8080/admin-login.jsp"
  echo "============================================================"
  echo ""
  ./mvnw jetty:run
fi
