/**
 * Copyright (c) 2023-present Plane Software, Inc. and contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 * See the LICENSE file for details.
 */

import type { RouteConfigEntry } from "@react-router/dev/routes";
import { layout, route } from "@react-router/dev/routes";

// AgilePlus extended routes
export const extendedRoutes: RouteConfigEntry[] = [
  layout("./(all)/[workspaceSlug]/(extended)/layout.tsx", [
    // Agents routes
    route("agents", "./(all)/[workspaceSlug]/(extended)/agents/page.tsx"),
    route("agents/:agentId", "./(all)/[workspaceSlug]/(extended)/agents/[agentId]/page.tsx"),
    // Worktrees routes
    route("worktrees", "./(all)/[workspaceSlug]/(extended)/worktrees/page.tsx"),
  ]),
];
