/**
 * Copyright (C) 2020 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

locals {
  instance_alias = var.instance_name == "" ? "drone-fly" : format("drone-fly-%s", var.instance_name)
}
