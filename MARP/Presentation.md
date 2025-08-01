---
marp: true
theme: uncover
_class: invert
#paginate: true
---

# Your slide deck

Start writing!

---
<!-- _backgroundColor: aqua -->
# How to write in markdown

---

# Same colour?

---

# 147756 - DocuSeal Testing
Spun up DocuSeal locally today to give it's self-hosted feature set a whirl. It's pretty good but the main issue is that it's designed to host reusable forms that once designed, are then sent out as templates so all the submissions are recorded under that template.

This would be very ineffecient for the use-case of one-off invoices being sent to a single person, as you would have to create the form fields manually every time.

They really do need a service where you upload the invoice and it automatically appends the required fields ready to go.
* * *
### 147781 - Smoothwall

Smoothwall getting locked out by the SMTP authentication block.

Added exclusions for `smoothwall@portregis.com`, and also the school's trusted IPs in case there's anything else that hasn't been missed by anyone else yet!

* * *
### 147756 - OpenSign Testing
Immediately better than DocuSeal, in that it has a much more intuitive process for one-off signature collections, this includes much quicker insertion of fields and management of submitted/completed documents. Overall, i think this is a closer fit to the school's needs than DocuSeal.