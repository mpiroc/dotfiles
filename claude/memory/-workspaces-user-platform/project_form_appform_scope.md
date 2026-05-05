---
name: form.AppForm scope is the form component, not the whole dialog
description: Wrap only FooForm in form.AppForm — never the parent dialog/page/route
type: project
originSessionId: 04d2e413-fb98-4917-946e-1e80f7a9a884
---
`<form.AppForm>` must be the nearest parent of the form component (e.g. `<FooForm />`), not a wrapper around the entire dialog, drawer, modal, or page that hosts the form. Only `FooForm` and its descendants should consume form context.

**Correct:**
```tsx
const FooDrawer = () => {
  const form = useFooForm()
  return (
    <Dialog.Root>
      <Dialog.Content>
        <form.AppForm>
          <FooForm ... />
        </form.AppForm>
      </Dialog.Content>
    </Dialog.Root>
  )
}
```

**Wrong** (too broad — dialog chrome is now inside form context):
```tsx
<Dialog.Root>
  <form.AppForm>
    <Dialog.Content>
      <FooForm />
    </Dialog.Content>
    <FloatingFooter><FooFormActions /></FloatingFooter>
  </form.AppForm>
</Dialog.Root>
```

**Why:** Form context is a tool for the form to coordinate its own fields and submit state. Leaking it to the dialog/page that hosts the form blurs the boundary, makes the form less portable, and pulls unrelated UI (footers, headers, navigation) into a context they don't need. Anything that needs form context — including the submit button, footer actions, or character counters — belongs *inside* `<FooForm>`, not as a sibling under the same `<form.AppForm>` wrapper.

**How to apply:** When writing or reviewing a form, check that `<form.AppForm>` directly wraps the form component (`<FooForm />`) and nothing else. If submit/footer actions need form state, they must be rendered inside `FooForm`. Some existing forms (e.g. parts of the add-findings drawer) wrap too broadly — fixing those is a separate concern, not a license to copy the pattern.
